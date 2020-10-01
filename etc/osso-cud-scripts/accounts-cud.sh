#! /bin/sh

# clear accounts database

DEFHOME="/home/user"
ACCOUNTS_DB=".accounts/accounts.db"

if test "x${HOME}" = "x"; then
  HOME=${DEFHOME}
  echo "$0: Warning, HOME is not defined, assuming '${HOME}'"
fi


if test -f "${HOME}/${ACCOUNTS_DB}"; then
  rm -f "${HOME}/${ACCOUNTS_DB}"
  rm -f "${HOME}/${ACCOUNTS_DB}-journal"
fi
