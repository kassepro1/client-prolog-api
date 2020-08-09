:- use_module(library('http/http_client')).
:- use_module(library('http/json')).
:- use_module(library('http/http_open')).
:- use_module(library(http/http_json)).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- http_handler(root(prove),prove,[]).


run :-
	http_server(http_dispatch, [port(8081)]).

prove(Request) :-
   URL = 'https://httpbin.org/post',
   http_read_json(Request, DictIn,[json_object(term)]),
   http_post(URL, json([DictIn]), Reply, [
   request_header('Accept'='application/json'),
   request_header('Content-Type'='application/json'),
   request_header('x-api-key'='secret')]),
   reply_json([Reply]).
