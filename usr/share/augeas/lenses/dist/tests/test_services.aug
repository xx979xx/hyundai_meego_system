(* Tests for the Services module *)

module Test_services =

  let example = "# a comment

tcpmux          1/tcp                           # TCP port service multiplexer
echo            7/udp
discard         9/tcp           sink null
systat          11/tcp          users
# another comment
whois++         63/tcp
z39.50		210/tcp		z3950 wais	# NISO Z39.50 database \n"

  test Services.lns get example =
    { "#comment" = "a comment" }
    { }
    { "service-name" = "tcpmux"
       { "port"     = "1" }
       { "protocol" = "tcp" }
       { "#comment" = "TCP port service multiplexer" } }
    { "service-name" = "echo"
       { "port"     = "7" }
       { "protocol" = "udp" } }
    { "service-name" = "discard"
       { "port"     = "9" }
       { "protocol" = "tcp" }
       { "alias"    = "sink" }
       { "alias"    = "null" } }
    { "service-name" = "systat"
       { "port"     = "11" }
       { "protocol" = "tcp" }
       { "alias"    = "users" } }
    { "#comment" = "another comment" }
    { "service-name" = "whois++"
       { "port" = "63" }
       { "protocol" = "tcp" } }
    { "service-name" = "z39.50"
       { "port"     = "210" }
       { "protocol" = "tcp" }
       { "alias"    = "z3950" }
       { "alias"    = "wais" }
       { "#comment" = "NISO Z39.50 database" } }

  (* We completely suppress empty comments *)
  test Services.record get "mtp\t\t1911/tcp\t\t\t#\n" =
    { "service-name" = "mtp"
       { "port"     = "1911" }
       { "protocol" = "tcp" } }

  test Services.lns get "sql*net\t\t66/tcp\t\t\t# Oracle SQL*NET\n" =
    { "service-name" = "sql*net"
       { "port"     = "66" }
       { "protocol" = "tcp" }
       { "#comment" = "Oracle SQL*NET" } }

  (* Fake service to check that we allow enoughspecial characters *)
  test Services.lns get "special.*+-/chars\t0/proto\n" =
    { "service-name" = "special.*+-/chars"
      { "port" = "0" }
      { "protocol" = "proto" } }


