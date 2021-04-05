open Progress

let bar ~total =
  let total_bytes =
    Format.asprintf "%a" (Printer.to_pp Units.Bytes.of_int) total
  in
  let open Line in
  let rate = rate Units.Bytes.of_float (module Int) in
  let eta = eta ~total (module Int) in
  list ~sep:(const " ")
    [ spinner ~color:(Progress.Ansi.Color.of_ansi `Green) ()
    ; const "[" ++ elapsed () ++ const "]"
    ; bar
        ~color:(Progress.Ansi.Color.of_ansi `Cyan)
        ~style:`ASCII ~total
        (module Int)
    ; bytes ++ const " / " ++ const total_bytes
    ; const "(" ++ rate ++ const ", " ++ eta ++ const ")"
    ]

let ( / ) = Stdlib.( / )

let run () =
  let total = 231231231 in
  let bar = make (bar ~total) in
  with_reporters bar @@ fun report ->
  let step = 22321 in
  for _ = 1 to (total / step) + 1 do
    report step;
    Unix.sleepf 0.0012
  done
