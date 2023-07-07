let marker_start msg size =
  let create_windows str size =
    let count = String.length str - size + 1 in
    Seq.init count (fun i -> (String.sub msg i size, i))
  in
  let find_marker size (str, i) =
    let str_to_list str =
      let rec reduce_right i acc =
        if i < 0 then acc else reduce_right (i - 1) (str.[i] :: acc)
      in
      reduce_right (String.length str - 1) []
    in
    let uniq_chars = List.sort_uniq compare (str_to_list str) in
    let has_marker = List.length uniq_chars == size in
    if has_marker then Some (i + size) else None
  in
  let windows = create_windows msg size in
  let marker_start = Seq.find_map (find_marker size) windows in
  print_endline (Int.to_string (Option.get marker_start))

let () =
  let msg = input_line (open_in "./bin/input-prod") in
  (* 1766 *)
  marker_start msg 4;
  (* 2383 *)
  marker_start msg 14
