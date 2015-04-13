%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  This file is part of Logtalk <http://logtalk.org/>
%  
%  Logtalk is free software. You can redistribute it and/or modify it under
%  the terms of the FSF GNU General Public License 3  (plus some additional
%  terms per section 7).        Consult the `LICENSE.txt` file for details.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% database for tests from the ISO/IEC 13211-1:1995/Cor.2:2012(en) standard, section 8.15.4.4

call_n_maplist(_Cont, []).
call_n_maplist(Cont, [E|Es]) :-
    call(Cont, E),
    call_n_maplist(Cont, Es).


:- object(tests,
	extends(lgtunit)).

	:- info([
		version is 1.1,
		author is 'Paulo Moura',
		date is 2015/04/13,
		comment is 'Unit tests for the ISO Prolog standard call/N built-in predicates.'
	]).

	:- discontiguous([
		succeeds/1, fails/1
	]).

	% tests from the ISO/IEC 13211-1:1995/Cor.2:2012(en) standard, section 8.15.4.4

	succeeds(iso_call_N_01) :-
		{call(integer, 3)}.

	succeeds(iso_call_N_02) :-
		{call(functor(F,c), 0)},
		F == c.

	succeeds(iso_call_N_03) :-
		{call(call(call(atom_concat, pro), log), Atom)},
		Atom == prolog.

	succeeds(iso_call_N_04) :-
		findall(X-Y, {call(;, X=1, Y=2)}, L),
		L = [1-_,_-2].

	fails(iso_call_N_05) :-
		{call(;, (true->fail), _X=1)}.

	succeeds(iso_call_N_06) :-
		{call_n_maplist(>(3), [1, 2])}.

	fails(iso_call_N_07) :-
		{call_n_maplist(>(3), [1, 2, 3])}.

	succeeds(iso_call_N_08) :-
		{call_n_maplist(=(_X), Xs)}, !,
		Xs == [].

	throws(lgt_call_N_09, error(instantiation_error,_)) :-
		{call(_, _)}.

	throws(lgt_call_N_10, error(type_error(callable,1),_)) :-
		{call(1, _)}.

	throws(lgt_call_N_11, error(instantiation_error,_)) :-
		{call(_, _, _)}.

	throws(lgt_call_N_12, error(type_error(callable,1),_)) :-
		{call(1, _, _)}.

	throws(lgt_call_N_13, error(instantiation_error,_)) :-
		{call(_, _, _, _)}.

	throws(lgt_call_N_14, error(type_error(callable,1),_)) :-
		{call(1, _, _, _)}.

	throws(lgt_call_N_15, error(instantiation_error,_)) :-
		{call(_, _, _, _, _)}.

	throws(lgt_call_N_16, error(type_error(callable,1),_)) :-
		{call(1, _, _, _, _)}.

	throws(lgt_call_N_17, error(instantiation_error,_)) :-
		{call(_, _, _, _, _, _)}.

	throws(lgt_call_N_18, error(type_error(callable,1),_)) :-
		{call(1, _, _, _, _, _)}.

	throws(lgt_call_N_19, error(instantiation_error,_)) :-
		{call(_, _, _, _, _, _, _)}.

	throws(lgt_call_N_20, error(type_error(callable,1),_)) :-
		{call(1, _, _, _, _, _, _)}.

	throws(lgt_call_N_21, error(instantiation_error,_)) :-
		{call(_, _, _, _, _, _, _, _)}.

	throws(lgt_call_N_22, error(type_error(callable,1),_)) :-
		{call(1, _, _, _, _, _, _, _)}.

:- end_object.
