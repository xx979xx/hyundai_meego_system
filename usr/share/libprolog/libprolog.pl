%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of libprolog
% 
% Copyright (C) 2010 Nokia Corporation.
% 
% This library is free software; you can redistribute
% it and/or modify it under the terms of the GNU Lesser General Public
% License as published by the Free Software Foundation
% version 2.1 of the License.
% 
% This library is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
% Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Lesser General Public
% License along with this library; if not, write to the Free Software
% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301
% USA.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



module(libprolog, [rules/2]).

%
% libprolog error detection glue
%
% The closer this code is to the beginning to the file the better (to
% minimize the possibility of errors before this glue code). Otherwise
% if prolog gives up parsing us we will fail to let libprolog know
% about errors.
%

% checking whether libprolog is loading
libprolog_loading :-
    catch(libprolog:loading, _, fail), !.

% mark/clear/test libprolog errors
libprolog_mark_error :-
    catch(libprolog:mark_error, _, true), !.

libprolog_clear_errors :-
    catch(libprolog:clear_errors, _, true), !.

libprolog_has_errors :-
    catch(libprolog:has_errors, _, fail), !.


%
% user:message_hook to detect and flag errors during loading to libprolog
%
:- multifile
	user:message_hook/3.
:- dynamic
	user:message_hook/3.

% if libprolog is loading a file, emit an error message and flag an error
user:message_hook(Term, error, _) :-
    libprolog_loading,
    Term = error(E, file(Path, Line, _LinePos, _CharPos)),
    write('ERROR: '), write(E), write('\n'),
    write('  in file '), write(Path), write('\n'),
    write('  detected on line '), write(Line), write('\n'),
    !, libprolog_mark_error.              % flag an error for libprolog

% warnings are emitted but ignored (maybe we will add a strict mode)
user:message_hook(Term, warning, _) :-
    libprolog_loading,
    Term = warning(_, file(Path, Line, _LinePos, _CharPos)),
    write('WARNING: '), write(Term), write('\n'),
    write('  in file '), write(Path), write('\n'),
    write('  detected on line '), write(Line), write('\n').



% This is a test syntax error ;-)


% 
% libprolog predicate/rule discovery glue code
%
% By convetion rules are exported from modules by defining a single-instance
% predicate Module:rules/1 which unifies its only argument with the list of
% rule predicates Module desires to export. The format is identical to the
% 2nd argument of module/2. Omitting to define Module:rules is treated
% equivalently to Module:rules([]).
%

rules(Defined, Undefined) :-
    subsystems(SubsystemList),
%   writef('subsystems %w', [SubsystemList]),
    rules_(SubsystemList, Defined, [], Undefined, []).

rules_([], Defined, Defined, Undefined, Undefined).
rules_([Module|T], Defined, DefinedAcc, Undefined, UndefinedAcc) :-
    module_rules(Module, ModuleRules),
    check_rules(Module, ModuleRules, DefinedRules, UndefinedRules),
    prefix_members(Module, DefinedRules, ModuleDefinedRules),
    prefix_members(Module, UndefinedRules, ModuleUndefinedRules),
    append(DefinedAcc, ModuleDefinedRules, DefinedNextAcc),
    append(UndefinedAcc, ModuleUndefinedRules, UndefinedNextAcc),
    rules_(T, Defined, DefinedNextAcc, Undefined, UndefinedNextAcc).


%
% Split Rules to Defined and Undefined.
%

check_rules(Module, Rules, Defined, Undefined) :-
    check_rules_(Module, Rules, Defined, [], Undefined, []).

check_rules_(_, [], Defined, Defined, Undefined, Undefined).
check_rules_(Module, [Rule|T], Defined, DefAcc, Undefined, UndefAcc) :-
    exports_predicate(Module, Rule),
    check_rules_(Module, T, Defined, [Rule|DefAcc], Undefined, UndefAcc).
check_rules_(Module, [Rule|T], Defined, DefAcc, Undefined, UndefAcc) :-
    not(exports_predicate(Module, Rule)),
    check_rules_(Module, T, Defined, DefAcc, Undefined, [Rule|UndefAcc]).


%
% Get the list of rules exported by Module.
%
% I think this should be equivalent (needs testing), ie. try evaluating
% Module:Rules(Rules). Upon exceptions force backtracking (fail) which
% will trigger the second clause, unifying Rules with []). Otherwise
% exceptions, prevent backtracking (cut).
%
% module_rules(Module, Rules) :-
%     catch(Module:rules(Rules), _, fail), !.
% module_rules(Module, []).
%
%
%

module_rules(Module, Rules) :-
    catch(Module:rules(Rules), _, fail),
    Module:rules(Rules), !.
module_rules(Module, []) :-
    catch(Module:rules(_), _, true), !.


%
% Check whether Module export Predicate (with a matching arity).
%

exports_predicate(Module, Predicate) :-
    export_list(Module, PredicateHeadList),
    has_predicate(Predicate, PredicateHeadList).

% Find Predicate/Arity in a list of predicate heads.
% export_list either returns exported predicates in the form
% name/arity, or as predicate heads (name(_G1, ..., _GN), where N is
% names arity). has_predicate deals with both.
has_predicate(Predicate, [Predicate|_]).
has_predicate(Predicate/Arity, [P|_]) :-
    functor(P, Predicate, Arity), !.
has_predicate(Predicate, [_|T]) :- has_predicate(Predicate, T).


%
% Prefix all members of a list with Prefix.
%

prefix_members(_, [], []).
prefix_members(Prefix, [H|T], Out) :-
    prefix_members_(Prefix, T, [Prefix:H], Out).

prefix_members_(_, [], Acc, Acc).
prefix_members_(P, [H|T], Acc, Out) :-
	prefix_members_(P, T, [P:H|Acc], Out).


%
% Tracing test
%

traced_port(call).
traced_port(redo).
traced_port(exit).
traced_port(fail).

map_port(call, call).
map_port(redo, redo).
map_port(exit, proven).
map_port(fail, failed).

prolog_trace_interception(Port, Frame, _Choice, continue) :-
    (not(traced_port(Port)), true) ;
    (prolog_frame_attribute(Frame, predicate_indicator, Predicate),
     map_port(Port, PortName),
     ((libprolog_trace_predicate(Predicate, Frame),
       trace_show(PortName, Predicate, Frame)) ;
      true)), !.

prolog_trace_interception(cut_call(_PC), _Frame, _Choice, continue).
prolog_trace_interception(cut_exit(_PC), _Frame, _Choice, continue).


libprolog_trace_predicate(Predicate, Frame) :-
    libprolog:trace_predicate(Predicate)
     ;
    (prolog_frame_attribute(Frame, parent, Parent),
     has_transitive_active(Parent)).

has_transitive_active(Frame) :-
    (prolog_frame_attribute(Frame, predicate_indicator, Predicate),
     libprolog:trace_predicate(Predicate, transitive))
     ;
    (prolog_frame_attribute(Frame, parent, Parent),
%     prolog_frame_attribute(Parent, goal, Goal),
%     writef('searching %w\n', [Goal]),
     has_transitive_active(Parent)).

trace_show(Port, Predicate, Frame) :-
    prolog_frame_attribute(Frame, goal, Goal),
    prolog_frame_attribute(Frame, level, Level),
    libprolog:trace_config(Predicate, Port, PortTraceType),
    trace_frame(Port, Predicate, Level, Goal, PortTraceType).
%    writef('%r', ['  ', Level]), writef('%w@%w %w\n', [Port, Level, Goal]).

trace_frame(Port, Predicate, Level, _Goal, short) :-
    writef('%r', ['  ', Level]), writef('%w@%w %w\n', [Port, Level, Predicate]).
trace_frame(Port, _Predicate, Level, Goal, detailed) :-
    writef('%r', ['  ', Level]), writef('%w@%w %w\n', [Port, Level, Goal]).
trace_frame(_, _, _, _, suppress) :- true.
trace_frame(_, _, _, _, unknown) :- true.


%show_frame(message, Frame) :-
%    prolog_frame_attribute(Frame, level, Level),
%    prolog_frame_attribute(Frame, goal, Goal),
%    indent_level(Level), writeln(Goal),
%    indent_level(Level), 
%    write('  has '),
%      ((Alternatives == true, write('more')); write('no more')),
%      write(' alternatives\n').


