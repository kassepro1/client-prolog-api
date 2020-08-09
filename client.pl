:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).

:- use_module(library(http/http_json)).

:- http_handler(root(prove),prove,[]).

run :-
	http_server(http_dispatch, [port(8081)]).

prove(Request) :-
   format(user_output,"I'm here~n",[]),
   http_read_json(Request, DictIn,[json_object(term)]),
   format(user_output,"Request is: ~p~n",[Request]),
   format(user_output,"DictIn is: ~p~n",[DictIn]),
   http_open("http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/andamentoTreno/S01520/10829",
   In, [request_header('Accept'='application/json'),
   request_header('Accept-Charset'='utf-8')]),
   json_read_dict(In, Data),
   DictOut=DictIn,
   reply_json(DictOut).




:- use_module(library('http/http_client')).
:- use_module(library('http/json')).
:- use_module(library('http/http_open')).

% Get the departure data of ns api on the selected trainstation
data_departures(CityCode, Data) :-
        First = 'https://ns-api.nl/reisinfo/api/v2/departures?maxJourneys=25&lang=nl&station=',
        Second = CityCode,
        atomic_concat(First, Second, HREF),
        setup_call_cleanup(
                http_open(HREF, In, [request_header('Accept'='application/json'), request_header('x-api-key'='secret')]),
                json_read_dict(In, Data),
                close(In)
        ).

departure_stations(Data, Test, Dest) :-
        Payload = Data.get(payload),
        Test = Payload.get(source),
        Departures = Payload.get(departures),
        Dest = Departures.get(destination).


JSON_Term = json([recipient=json([id=Sender_Id]), message=json([text=Message_Text])]),
http_open(
		FB_Post_URL,
		Stream,
		[	post(json(JSON_Term)),
			status_code(Code)
		]
		),

	close(Stream),
	http_log("post http code is ~w~n", Code).

