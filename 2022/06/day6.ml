let str_to_list text =
  let rec reduce index acc =
    if index < 0 then acc else reduce (index - 1) (text.[index] :: acc)
  in
  reduce (String.length text - 1) []

let solve problem_size =
  (* window function that looks backwards *)
  let window_backwards message index =
    let length = index - problem_size in
    let substring = String.sub message length problem_size in
    substring
  in
  (* problem-specific that look for a marker window *)
  let does_start message index =
    let maybe_marker = window_backwards message index in
    let unique_chars = List.sort_uniq compare (str_to_list maybe_marker) in
    let is_marker = List.length unique_chars == problem_size in
    if is_marker then Some index else None
  in

  let message = input_line (open_in "./day6.prod") in
  let window_count = String.length message - problem_size - 1 in
  let maybe_answers = List.init window_count (fun i -> i + problem_size) in
  let answer = List.find_map (does_start message) maybe_answers in
  Printf.printf "%d\n" (Option.get answer)

(* main *)
let () =
  (* 1766 *)
  solve 4;
  (* 2383 *)
  solve 14
