%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This file is part of Logtalk <https://logtalk.org/>
%  Copyright 1998-2019 Paulo Moura <pmoura@logtalk.org>
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


:- object(tutor).

	:- info([
		version is 0.1,
		author is 'Paulo Moura',
		date is 2019/07/22,
		comment is 'This object adds explanations and suggestions to selected compiler warning and error messages.'
	]).

	% intercept all compiler warning and error messages

	:- multifile(logtalk::message_hook/4).
	:- dynamic(logtalk::message_hook/4).

	logtalk::message_hook(Message, Kind, core, Tokens) :-
		logtalk::message_prefix_stream(Kind, core, Prefix, Stream),
		phrase(explain(Message), ExplanationTokens),
		list::append(Tokens0, [nl], Tokens),
		list::append([begin(Kind,Ctx)| Tokens0], ExplanationTokens, ExtendedTokens0),
		list::append(ExtendedTokens0, [end(Ctx)], ExtendedTokens),
		logtalk::print_message_tokens(Stream, Prefix, ExtendedTokens).

	% errors


	% warnings

	explain(declared_static_predicate_called_but_not_defined(_, _, _, _, _)) -->
		[	'Calls to declared, static, but undefined predicates fail.'-[], nl,
			'Predicate definition missing? Misspelt? Should the predicate be declared dynamic?'-[], nl, nl
		].
	explain(unknown_predicate_called_but_not_defined(_, _, _, _, _)) -->
		[	'Calls to unknown and undefined predicates generate a runtime error.'-[], nl,
			'Misspelt the predicate name? Wrong number of predicate arguments?'-[], nl, nl
		].

	explain(redefined_logtalk_built_in_predicate(_, _, _, _, _)) -->
		[	'Avoid redefining Logtalk built-in predicates as it hurts code readbility.'-[], nl,
			'Or were you not aware that there is already a built-in predicate with that name?'-[], nl, nl
		].

	explain(redefined_prolog_built_in_predicate(_, _, _, _, _)) -->
		[	'Is the redefinition a consequence of making the code portable?'-[], nl,
			'Or were you not aware that there is already a built-in predicate with that name?'-[], nl, nl
		].

	explain(goal_is_always_true(_, _, _, _, _)) -->
		['Misspelt variable in goal? Wrong operator or built-in predicate?'-[], nl, nl].

	explain(goal_is_always_false(_, _, _, _, _)) -->
		['Misspelt variable in goal? Wrong operator or built-in predicate?'-[], nl, nl].

	explain(no_matching_clause_for_goal(_, _, _, _, _)) -->
		[	'Calls to locally defined predicates without a clause with a matching head fail.'-[], nl,
			'Misspelt predicate argument? Predicate definition incomplete?'-[], nl, nl
		].

	explain(missing_reference_to_built_in_protocol(_, _, Type, _, Protocol)) -->
		[	'The ~w implements reserved but user-defined predicates specified in the ~q protocol.'-[Type, Protocol], nl,
			'Fix this warning by adding the implements(~q) argument to the ~w opening directive.'-[Protocol, Type], nl, nl
		].

	explain(duplicated_directive(_, _, _, _, _)) -->
		['Easy to fix warning: simply delete or correct the duplicated directive.'-[], nl, nl].

	explain(non_standard_predicate_call(_, _, _, _, _)) -->
		[	'Calls to non-standard built-in predicates may make your code non-portable when using'-[], nl,
			'other backend compilers. Are there portable alternatives that you can use instead?'-[], nl, nl
		].
	explain(non_standard_arithmetic_function_call(_, _, _, _, _)) -->
		[	'Calls to non-standard built-in functions may make your code non-portable when using'-[], nl,
			'other backend compilers. Are there portable alternatives that you can use instead?'-[], nl, nl
		].

	explain(reference_to_unknown_object(_, _, _, _, _)) -->
		['Misspelt object name? Wrong file loading order? Circular references?'-[], nl, nl].

	explain(reference_to_unknown_protocol(_, _, _, _, _)) -->
		['Misspelt protocol name? Wrong file loading order?'-[], nl, nl].

	explain(reference_to_unknown_category(_, _, _, _, _)) -->
		['Misspelt category name? Wrong file loading order?'-[], nl, nl].

	explain(reference_to_unknown_module(_, _, _, _, _)) -->
		['Misspelt module name? Wrong file loading order? Circular references?'-[], nl, nl].

	explain(missing_predicate_directive(_, _, Type, _, (dynamic), Predicate)) -->
		[	'The ~w updates the ~q predicate but does not declare it dynamic.'-[Type, Predicate], nl,
			'Add a ":- dynamic(~q)." directive to the ~w to supress this warning.'-[Predicate, Type], nl, nl
		].

	explain(missing_scope_directive(_, _, _, _, Directive, _)) -->
		['But there is a ~w directive for the predicate.'-[Directive], nl, nl].

	explain(camel_case_entity_name(_, _, _, _)) -->
		['Coding guidelines advise the use of underscores to separate words in entity names.'-[], nl, nl].

	explain(camel_case_predicate_name(_, _, _, _, _)) -->
		['Coding guidelines advise the use of underscores to separate words in predicate names.'-[], nl, nl].

	explain(camel_case_non_terminal_name(_, _, _, _, _)) -->
		['Coding guidelines advise the use of underscores to separate words in non-terminal names.'-[], nl, nl].

	explain(non_camel_case_variable_name(_, _, _, _, _)) -->
		['Coding guidelines advise the use of CamelCase in variable names with multiple words.'-[], nl, nl].

	explain(non_camel_case_variable_name(_, _, _)) -->
		['Coding guidelines advise the use of CamelCase in variable names with multiple words.'-[], nl, nl].

	explain(variable_names_differ_only_on_case(_, _, _, _, _, _)) -->
		[	'Variable names differing only on case hurt code readbility.'-[], nl,
		 	'Consider renaming one or both variables to better clarify their meaning.'-[], nl, nl
		].

	explain(variable_names_differ_only_on_case(_, _, _, _)) -->
		['Variables differing only on case hurt code readbility.'-[], nl, nl].

	explain(singleton_variables(_, _, _, _, [_], _)) -->
		[	'Misspelt variable name? Don''t care variable?'-[], nl,
		 	'In the later case, use instead an anonymous variable.'-[], nl, nl
		].
	explain(singleton_variables(_, _, _, _, [_, _| _], _)) -->
		[	'Misspelt variable names? Don''t care variables?'-[], nl,
		 	'In the later case, use instead anonymous variables.'-[], nl, nl
		].

	explain(singleton_variables(_, _, [_], _)) -->
		[	'Misspelt variable name? Don''t care variable?'-[], nl,
		 	'In the later case, use instead an anonymous variable.'-[], nl, nl
		].
	explain(singleton_variables(_, _, [_, _| _], _)) -->
		[	'Misspelt variable names? Don''t care variables?'-[], nl,
		 	'In the later case, use instead anonymous variables.'-[], nl, nl
		].

	% catchall clause

	explain(_) --> [nl].

:- end_object.
