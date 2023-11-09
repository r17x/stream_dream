(* 
   TODO Latest stream to do is run server-reason-react (SSR React with OCaml - Dream).
   *)
let hello who = "hello " ^  who

let echoHandler id request = Dream.html (Dream.param request id)

(* TODO
   making simple request HTTP with url, that URL has been get from Param Route
   Basicly is same as CoHTTP but with Dream approach - we need to dive into 

let uncorsHandler id request = 
  let url = Dream.param request id in 
  let req = Dream.request url in
  let req = Dream.client req in
  Dream.respond (req)

  *)
   


let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/" (fun _ ->
      Dream.html (hello "world"));

    Dream.get "/echo/:id" (echoHandler "id");

    (* TODO: /un/:url -> 
    Dream.get "/un/:url" (uncorsHandler "url");
      *)


  ]
