%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  This file is part of Logtalk <http://logtalk.org/>
%  Copyright 1998-2016 Paulo Moura <pmoura@logtalk.org>
%  
%  Licensed under the Apache License, Version 2.0 (the "License");
%  you may not use this file except in compliance with the License.
%  You may obtain a copy of the License at
%  
%      http://www.apache.org/licenses/LICENSE-2.0
%  
%  Unless required by applicable law or agreed to in writing, software
%  distributed under the License is distributed on an "AS IS" BASIS,
%  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%  See the License for the specific language governing permissions and
%  limitations under the License.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- category(arbitrary,
	complements(type)).

	:- info([
		version is 1.0,
		author is 'Paulo Moura',
		date is 2016/08/21,
		comment is 'Adds predicates for generating random values for selected types to the library "type" object.',
		remarks is [
			'Atom character sets' - 'When generating atoms or character codes, or terms that contain them, it is possible to choose a character set (ascii_printable, ascii_full, byte, unicode_bmp, or unicode_full) using the parameterizable types. Default is ascii_printable.'
		]
	]).

	:- public(arbitrary/1).
	:- multifile(arbitrary/1).
	% workaround the lack of support for static multifile predicates in Qu-Prolog and XSB
	:- if((current_logtalk_flag(prolog_dialect, Dialect), (Dialect==xsb; Dialect==qp))).
		:- dynamic(arbitrary/1).
	:- endif.
	:- mode(arbitrary(?callable), zero_or_more).
	:- info(arbitrary/1, [
		comment is 'Table of defined types for which an arbitrary value can be generated. A new type can be registered by defining a clause for this predicate and adding a clause for the arbitrary/2 multifile predicate.',
		argnames is ['Type']
	]).

	:- public(arbitrary/2).
	:- multifile(arbitrary/2).
	% workaround the lack of support for static multifile predicates in Qu-Prolog and XSB
	:- if((current_logtalk_flag(prolog_dialect, Dialect), (Dialect==xsb; Dialect==qp))).
		:- dynamic(arbitrary/2).
	:- endif.
	:- mode(arbitrary(@callable, -term), zero_or_one).
	:- info(arbitrary/2, [
		comment is 'Generates an arbitrary term of the specified type. Fails if the given type is not supported. A new generator can be added by defining a clause for this predicate and registering it by adding a clause for the arbitrary/1 multifile predicate.',
		argnames is ['Type', 'Term']
	]).

	:- public(shrink/3).
	:- multifile(shrink/3).
	% workaround the lack of support for static multifile predicates in Qu-Prolog and XSB
	:- if((current_logtalk_flag(prolog_dialect, Dialect), (Dialect==xsb; Dialect==qp))).
		:- dynamic(shrink/3).
	:- endif.
	:- mode(shrink(@callable, @term, -term), zero_or_one).
	:- info(shrink/3, [
		comment is 'Shrinks a value to a smaller value. Fails if the given type is not supported or if shrinking the value is not possible. Support for a new type can be added by defining a clause for this predicate.',
		argnames is ['Type', 'Large', 'Small']
	]).

	% Logtalk entity types
	arbitrary(entity).
	arbitrary(object).
	arbitrary(protocol).
	arbitrary(category).
	:- if(current_logtalk_flag(modules, supported)).
		arbitrary(module).
	:- endif.
	% Logtalk entity identifiers
	arbitrary(entity_identifier).
	arbitrary(object_identifier).
	arbitrary(protocol_identifier).
	arbitrary(category_identifier).
	:- if(current_logtalk_flag(modules, supported)).
		arbitrary(module_identifier).
	:- endif.
	% Logtalk events
	arbitrary(event).
	% base types from the Prolog standard
	arbitrary(term).
	arbitrary(var).
	arbitrary(nonvar).
	arbitrary(atomic).
	arbitrary(atom).
	arbitrary(number).
	arbitrary(integer).
	arbitrary(float).
	arbitrary(compound).
	arbitrary(callable).
	% number derived types
	arbitrary(positive_integer).
	arbitrary(negative_integer).
	arbitrary(non_positive_integer).
	arbitrary(non_negative_integer).
	arbitrary(byte).
	arbitrary(character_code).
	arbitrary(character_code(_CharSet)).
	% atom derived types
	arbitrary(boolean).
	arbitrary(character).
	arbitrary(order).
	arbitrary(non_empty_atom).
	arbitrary(atom(_CharSet)).
	arbitrary(non_empty_atom(_CharSet)).
	% compound derived types
	arbitrary(predicate_indicator).
	arbitrary(non_terminal_indicator).
	arbitrary(predicate_or_non_terminal_indicator).
	arbitrary(clause).
	arbitrary(list).
	arbitrary(non_empty_list).
	arbitrary(list(_Type)).
	arbitrary(non_empty_list(_Type)).
	arbitrary(pair).
	arbitrary(pair(_KeyType, _ValueType)).
	arbitrary(between(_Type, _Lower, _Upper)).
	arbitrary(property(_Type, _LambdaExpression)).
	% other types
	arbitrary(one_of(_Type, _Set)).
	arbitrary(var_or(_Type)).
	arbitrary(types(_Types)).

	% entities

	:- if(current_logtalk_flag(modules, supported)).

	arbitrary(entity, Arbitrary) :-
		random::member(ArbitraryType, [object, protocol, category, module]),
		arbitrary(ArbitraryType, Arbitrary).

	:- else.

	arbitrary(entity, Arbitrary) :-
		random::member(ArbitraryType, [object, protocol, category]),
		arbitrary(ArbitraryType, Arbitrary).

	:- endif.

	arbitrary(object, Arbitrary) :-
		findall(Object, current_object(Object), Objects),
		random::member(Arbitrary, Objects).

	arbitrary(protocol, Arbitrary) :-
		findall(Protocol, current_object(Protocol), Protocols),
		random::member(Arbitrary, Protocols).

	arbitrary(category, Arbitrary) :-
		findall(Category, current_category(Category), Categories),
		random::member(Arbitrary, Categories).

	:- if(current_logtalk_flag(modules, supported)).

	arbitrary(module, Arbitrary) :-
		findall(Module, current_module(Module), Modules),
		random::member(Arbitrary, Modules).

	:- endif.

	% entity identifiers

	arbitrary(entity_identifier, Arbitrary) :-
		arbitrary(atom(ascii_printable), Arbitrary).

	arbitrary(object_identifier, Arbitrary) :-
		random::member(Type, [atom(ascii_printable), compound]),
		arbitrary(Type, Arbitrary).

	arbitrary(protocol_identifier, Arbitrary) :-
		arbitrary(atom(ascii_printable), Arbitrary).

	arbitrary(category_identifier, Arbitrary) :-
		random::member(Type, [atom(ascii_printable), compound]),
		arbitrary(Type, Arbitrary).

	:- if(current_logtalk_flag(modules, supported)).

	arbitrary(module_identifier, Arbitrary) :-
		arbitrary(atom(ascii_printable), Arbitrary).

	:- endif.

	% events

	arbitrary(event, Arbitrary) :-
		random::member(Arbitrary, [before, after]).

	% Prolog base types

	arbitrary(term, Arbitrary) :-
		findall(
			Type,
			(	arbitrary(Type),
				% prevent recursion
				Type \== term,
				% discard parametric types
				ground(Type)
			),
			Types
		),
		random::member(ArbitraryType, Types),
		arbitrary(ArbitraryType, Arbitrary).

	arbitrary(var, _).

	arbitrary(nonvar, Arbitrary) :-
		random::member(Type, [atom(ascii_printable), integer, float, compound]),
		arbitrary(Type, Arbitrary).

	arbitrary(atomic, Arbitrary) :-
		random::member(Type, [atom(ascii_printable), integer, float]),
		arbitrary(Type, Arbitrary).

	arbitrary(atom, Arbitrary) :-
		arbitrary(list(character_code(ascii_printable)), Codes),
		atom_codes(Arbitrary, Codes).

	arbitrary(number, Arbitrary) :-
		random::member(Type, [integer, float]),
		arbitrary(Type, Arbitrary).

	arbitrary(integer, Arbitrary) :-
		random::between(-1000, 1000, Arbitrary).

	arbitrary(float, Arbitrary) :-
		arbitrary(integer, Integer),
		random::random(Factor),
		Arbitrary is Integer * Factor.

	arbitrary(compound, Arbitrary) :-
		arbitrary(atom(ascii_printable), Functor),
		arbitrary(list, Arguments),
		Arbitrary =.. [Functor| Arguments].

	arbitrary(callable, Arbitrary) :-
		random::member(Type, [atom(ascii_printable), compound]),
		arbitrary(Type, Arbitrary).

	% atom derived types

	arbitrary(boolean, Arbitrary) :-
		random::member(Arbitrary, [true, false]).

	arbitrary(character, Arbitrary) :-
		arbitrary(character_code, Code),
		char_code(Arbitrary, Code).

	arbitrary(order, Arbitrary) :-
		random::member(Arbitrary, [(<), (=), (>)]).

	arbitrary(non_empty_atom, Arbitrary) :-
		arbitrary(character_code(ascii_printable), Code),
		arbitrary(list(character_code(ascii_printable)), Codes),
		atom_codes(Arbitrary, [Code| Codes]).

	arbitrary(atom(CharSet), Arbitrary) :-
		arbitrary(list(character_code(CharSet)), Codes),
		atom_codes(Arbitrary, Codes).		

	arbitrary(non_empty_atom(CharSet), Arbitrary) :-
		arbitrary(character_code(CharSet), Code),
		arbitrary(list(character_code(CharSet)), Codes),
		atom_codes(Arbitrary, [Code| Codes]).

	% number derived types

	arbitrary(positive_integer, Arbitrary) :-
		random::between(1, 1000, Arbitrary).

	arbitrary(negative_integer, Arbitrary) :-
		random::between(-1000, -1, Arbitrary).

	arbitrary(non_negative_integer, Arbitrary) :-
		random::between(0, 1000, Arbitrary).

	arbitrary(non_positive_integer, Arbitrary) :-
		random::between(-1000, 0, Arbitrary).

	arbitrary(byte, Arbitrary) :-
		random::between(0, 255, Arbitrary).

	arbitrary(character_code, Arbitrary) :-
		code_upper_limit(Upper),
		random::between(0, Upper, Arbitrary).

	arbitrary(character_code(CharSet), Arbitrary) :-
		(	CharSet == ascii_full ->
			random::between(0, 127, Arbitrary)
		;	CharSet == ascii_printable ->
			random::between(32, 126, Arbitrary)
		;	CharSet == byte ->
			random::between(0, 255, Arbitrary)
		;	CharSet == unicode_bmp ->
			random::between(0, 65535, Arbitrary)
		;	CharSet == unicode_full ->
			random::between(0, 1114111, Arbitrary)
		;	random::between(32, 126, Arbitrary)
		).

	% compound derived types

	arbitrary(predicate_indicator, Name/Arity) :-
		arbitrary(non_empty_atom(ascii_printable), Name),
		arbitrary(between(integer,0,42), Arity).

	arbitrary(non_terminal_indicator, Name//Arity) :-
		arbitrary(non_empty_atom(ascii_printable), Name),
		arbitrary(between(integer,0,42), Arity).

	arbitrary(predicate_or_non_terminal_indicator, Arbitrary) :-
		random::member(ArbitraryType, [predicate_indicator, non_terminal_indicator]),
		arbitrary(ArbitraryType, Arbitrary).

	arbitrary(clause, Arbitrary) :-
		random::member(Kind, [fact, rule]),
		(	Kind == fact ->
			arbitrary(callable, Arbitrary)
		;	% Kind == rule,
			Arbitrary = (ArbitraryHead :- ArbitraryBody),
			arbitrary(callable, ArbitraryHead),
			arbitrary(callable, ArbitraryBody)
		).

	arbitrary(list, Arbitrary) :-
		arbitrary(list(types([var,atom(ascii_printable),integer,float])), Arbitrary).

	arbitrary(non_empty_list, Arbitrary) :-
		arbitrary(non_empty_list(types([var,atom(ascii_printable),integer,float])), Arbitrary).

	arbitrary(list(Type), Arbitrary) :-
		random::between(0, 42, Length),
		length(Arbitrary, Length),
		findall(
			ArbitraryValue,
			(member(ArbitraryValue, Arbitrary), arbitrary(Type, ArbitraryValue)),
			Arbitrary
		).

	arbitrary(non_empty_list(Type), Arbitrary) :-
		random::between(1, 42, Length),
		length(Arbitrary, Length),
		findall(
			ArbitraryValue,
			(member(ArbitraryValue, Arbitrary), arbitrary(Type, ArbitraryValue)),
			Arbitrary
		).

	arbitrary(pair, ArbitraryKey-ArbitraryValue) :-
		arbitrary(nonvar, ArbitraryKey),
		arbitrary(nonvar, ArbitraryValue).

	arbitrary(pair(KeyType, ValueType), ArbitraryKey-ArbitraryValue) :-
		arbitrary(KeyType, ArbitraryKey),
		arbitrary(ValueType, ArbitraryValue).

	arbitrary(between(Type, Lower, Upper), Arbitrary) :-
		(	Type == integer ->
			random::between(Lower, Upper, Arbitrary)
		;	Type == float ->
			random::random(Random),
			Arbitrary is Random * (Upper-Lower) + Lower
		;	Type == number ->
			random::random(Random),
			Arbitrary is Random * (Upper-Lower) + Lower
		;	% not a number
			repeat,
			arbitrary(Type, Arbitrary),
			Lower @=< Arbitrary, Arbitrary @=< Upper,
			!
		).

	arbitrary(property(Type, [Arbitrary]>>Goal), Arbitrary) :-
		arbitrary(Type, Arbitrary),
		{call(Goal)},
		!.

	arbitrary(one_of(_Type, Set), Arbitrary) :-
		random::member(Arbitrary, Set).

	arbitrary(var_or(Type), Arbitrary) :-
		random::member(VarOrType, [var, Type]),
		arbitrary(VarOrType, Arbitrary).

	arbitrary(types(Types), Arbitrary) :-
		random::member(Type, Types),
		arbitrary(Type, Arbitrary).

	% auxiliary predicates; we could use the Logtalk standard library
	% for some of them but we prefer to avoid any object dependencies

	code_upper_limit(Upper) :-
		current_logtalk_flag(unicode, Unicode),
		code_upper_limit(Unicode, Upper).

	% 0x10FFFF
	code_upper_limit(full, 1114111).
	% 0xFFFF
	code_upper_limit(bmp, 65535).
	% 0xFF
	code_upper_limit(unsupported, 255).

	member(Head, [Head| _]).
	member(Head, [_| Tail]) :-
		member(Head, Tail).

:- end_category.
