open Hello_t
open Lwt_io

let writing =
  let date = [{ year = 1970; month = 1; day = 1 };{ year = 1970; month = 1; day = 1 }] in
  let%lwt stg = with_file ~flags:([Unix.O_WRONLY; Unix.O_CREAT; Unix.O_NONBLOCK]) ~mode: Output "test.txt" (fun channel -> write channel (Hello_j.string_of_t date)) in
  Lwt.return_unit

let reading =
  let%lwt content = with_file ~mode: Input "test.txt" (fun channel -> read channel) in
  let () = print_endline ("content:" ^ "\"" ^ content ^"\"") in
  let hello = Hello_j.t_of_string content in
  let _ = List.map (fun hello -> Printf.printf "year: %d, month: %d, day: %d\n" hello.year hello.month hello.day) hello in
  Lwt.return_unit


let _ = Lwt_main.run (Lwt.join [reading;writing])

let database = Database.create_database "test.txt" (module Hello_j)