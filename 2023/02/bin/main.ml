let nb_reds_max = 12
let nb_greens_max = 13
let nb_blues_max = 14

let split_once ch str =
  let halfs = String.split_on_char ch str in
  match halfs with
  | [] -> None
  | fst :: snd -> Some (fst, String.concat "" snd)
;;

let split_once_expc ch str =
  match split_once ch str with
  | None -> failwith "Puzzle input is not illformatted"
  | Some (fst, snd) -> fst, snd
;;

let part_one lines =
  let check_game line =
    let check_set str =
      let check_nb_cubes acc str =
        let this =
          match String.trim str |> split_once_expc ' ' with
          | nb, "red" -> String.trim nb |> int_of_string <= nb_reds_max
          | nb, "green" -> String.trim nb |> int_of_string <= nb_greens_max
          | nb, "blue" -> String.trim nb |> int_of_string <= nb_blues_max
          | _ -> failwith "Puzzle input is not illformatted"
        in
        acc && this
      in
      String.split_on_char ',' str |> List.fold_left check_nb_cubes true
    in
    let left, right = split_once_expc ':' line in
    let game = split_once_expc ' ' left |> snd |> int_of_string in
    let sets = String.split_on_char ';' right |> List.map check_set in
    if List.for_all (fun b -> b) sets then Some game else None
  in
  List.filter_map check_game lines |> List.fold_left Int.add 0
;;

let tuple3_max (a1, b1, c1) (a2, b2, c2) = max a1 a2, max b1 b2, max c1 c2

let part_two lines =
  let game_power line =
    let nb_cubes_max acc str =
      let nb_cubes acc str =
        let this =
          match String.trim str |> split_once_expc ' ' with
          | nb, "red" -> String.trim nb |> int_of_string, 0, 0
          | nb, "green" -> 0, String.trim nb |> int_of_string, 0
          | nb, "blue" -> 0, 0, String.trim nb |> int_of_string
          | _ -> failwith "Puzzle input is not illformatted"
        in
        tuple3_max acc this
      in
      let this = String.split_on_char ',' str |> List.fold_left nb_cubes (0, 0, 0) in
      tuple3_max acc this
    in
    let right = split_once_expc ':' line |> snd in
    let rgb = String.split_on_char ';' right |> List.fold_left nb_cubes_max (0, 0, 0) in
    let r, g, b = rgb in
    r * g * b
  in
  List.map game_power lines |> List.fold_left Int.add 0
;;

let () =
  let lines =
    open_in
      (if Array.length Sys.argv == 1
       then "./bin/input.test.txt"
       else "./bin/input.prod.txt")
    |> In_channel.input_lines
  in
  (* 2449 *)
  Printf.printf "ONE: %d\n" (part_one lines);
  (* 63981 *)
  Printf.printf "TWO: %d\n" (part_two lines)
;;
