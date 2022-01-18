---
title: Parsing mathematical expressions and calculating the result
author: ben-wendt
layout: post
date: 2013-07-19
template: article.pug
url: /2013/07/19/parsing-mathematical-expressions-and-calculating-the-result/
categories:
  - PHP
tags:
  - math
  - parsing
  - strings
---
Given a string like `2 * 2 + 2`, how would you calculate the value? It&#8217;s necessary to tokenize the string, parse those tokens, and apply the order of operations to the parsed data.

Here is the function to throw a string at.

<pre class="brush: php; title: ; notranslate" title="">&lt;?php

function calculate($input) {
	$tokens = tokenize($input);
	$parsed = parse_tokens($tokens);
	$result = calculate_from_parsed($parsed);
	return $result;
}
</pre>

And I just rely on PHP&#8217;s built in tokenizer, which I throw a wrapper around.

<pre class="brush: php; title: ; notranslate" title="">function tokenize($input) {
	
	$tokens = token_get_all("&lt;?php $input");
	return $tokens;
}
</pre>

So here is the first function that really does anything. Note that only pedmas rules are followed. The parser doesn&#8217;t deal with anything like exponentiation, trig functions, etc.

<pre class="brush: php; title: ; notranslate" title="">function parse_tokens($tokens) {
	
	if (!is_array($tokens)) {
		// invalid input.
		return false;
	}
	
	$expecting = null;
	
	$parsed_tokens = array();
	$skip_to = 0;
	
	foreach($tokens as $token_number =&gt; $token) {
		if ($token_number &lt; $skip_to) continue;
		if (is_array($token) && isset($token[0])) {
			switch($token[0]) {
				case 305 :
				case 306 :
					if (!is_null($expecting) && $expecting != 'number') {
						exit('error 1: unexpected token ' . print_r($token, true) . "nn");
					}
					$expecting = 'operator';
					$parsed_tokens[] = $token[1];
				case 372:
				case 375:
					// whitespace
					continue;
					
				default :
					exit('error: unhandled token ' . print_r($token, true) . "nn");
			}
		} else {
			
			if (!is_null($expecting) && $expecting != 'operator' && $token != '(' && $token != ')') {
				exit('error 2: unexpected token ' . print_r($token, true) . "nn");
			}
			switch($token) {
				case '(' : 
					
					$new_tokens = array();
					$parentheses_count = 1;
					for ($i = $token_number + 1; $i &lt; count($tokens); $i++) {
						if ($tokens[$i] == '(') {
							$parentheses_count ++;

						} else if ($tokens[$i] == ')') {
							$parentheses_count --;
						}
						
						if ($parentheses_count != 0) {
							$new_tokens[] = $tokens[$i];
						} else {
							$skip_to = $i;
							$expecting = 'operator';
							break;
						}
					}
					
					$parsed_tokens[] = parse_tokens($new_tokens);
					$expecting = 'operator';
					break;
				case '+' :
				case '-' :
				case '*' :
				case '/' :
					$parsed_tokens[] = $token;
					$expecting = 'number';
					break;
			}
		}
		
	}
	return $parsed_tokens;
}
</pre>

Now run through the parsed tokens, apply the order of operations, and run until there is a result.

<pre class="brush: php; title: ; notranslate" title="">function calculate_from_parsed($parsed_tokens) {

	if (count($parsed_tokens) == 1 && !is_array($parsed_tokens[0])) {
		return $parsed_tokens[0];
	} else if (count($parsed_tokens) == 1 && is_array($parsed_tokens[0])) {
		return calculate_from_parsed($parsed_tokens[0]);
	} else {
		foreach($parsed_tokens as $token_number =&gt; $parsed_token) {
			if (is_array($parsed_token)) {
				$parsed_tokens[$token_number] = calculate_from_parsed($parsed_token);
			}
		}
		
		while (count($parsed_tokens) &gt; 1) {
			$continue = false;
			foreach($parsed_tokens as $token_number =&gt; $parsed_token) {
				$previous_token_pair = get_previous_token_pair($parsed_tokens, $token_number);
				$previous_token = $previous_token_pair[0];
				$previous_token_index = $previous_token_pair[1];
				if ($parsed_token == '*' || $parsed_token == '/') {
					if ($parsed_token == '*') {
						$parsed_tokens[$token_number] = $previous_token * $parsed_tokens[$token_number + 1];
						unset($parsed_tokens[$previous_token_index], $parsed_tokens[$token_number + 1]);
						$continue = true;
						break;
					} else if ($parsed_token == '/') {
						$parsed_tokens[$token_number] = $previous_token / $parsed_tokens[$token_number + 1];
						unset($parsed_tokens[$previous_token_index], $parsed_tokens[$token_number + 1]);
						$continue = true;
						break;
					}
				}
			}
			if ($continue) continue;
			
			$parsed_tokens = array_values($parsed_tokens);
			
			foreach($parsed_tokens as $token_number =&gt; $parsed_token) {
				$previous_token_pair = get_previous_token_pair($parsed_tokens, $token_number);
				$previous_token = $previous_token_pair[0];
				$previous_token_index = $previous_token_pair[1];
				if ($parsed_token == '+' || $parsed_token == '-') {
					if ($parsed_token == '+') {
						$parsed_tokens[$token_number] = $previous_token + $parsed_tokens[$token_number + 1];
						unset($parsed_tokens[$previous_token_index], $parsed_tokens[$token_number + 1]);
						break;
					} else if ($parsed_token == '-') {
						$parsed_tokens[$token_number] = $previous_token - $parsed_tokens[$token_number + 1];
						unset($parsed_tokens[$previous_token_index], $parsed_tokens[$token_number + 1]);
						break;
					}
				}
			}
			
			$parsed_tokens = array_values($parsed_tokens);
		}
		if (count($parsed_tokens) == 1) {
			$parsed_tokens = array_values($parsed_tokens);
			return $parsed_tokens[0];
		}
	}
}
</pre>

And since we pop results out of the array as we go we need a helper function for retrieving the previous populated element in an array.

<pre class="brush: php; title: ; notranslate" title="">function get_previous_token_pair($tokens, $token_number) {
	$return = false;
	for ($i = $token_number - 1; $i &gt; -1; $i--) {
		if (isset($tokens[$i])) {
			$return = array($tokens[$i], $i);
			break;
		}
	}
	return $return;
}
</pre>

And here is a little test suite, all of which pass:

<pre class="brush: php; title: ; notranslate" title="">$tests = array(
	array('(1.1 + ((1)))', 2.1),
	array('2 + 2', 4),
	array('1 + 1 + 1 + 1 + 1    + 1 + 1 + 1 + 1 + 1      + 1 +1 + 1 + 1 + 1', 15),
	array('2*(1 + 1 + 1 + 1 + 1)    + 3*(1 + 1 + 1 + 1 + 1)      + 4*(1 +1 + 1 + 1 + 1)', 45),
	array('(1 + 1 + 1 + 1 + 1)*2 + (1 + 4)*3 + (1 +1 + .5+.5 + 1 + 1)*5', 50),
	array('2 * 2', 4),
	array('2 * (1-1)', 0),
	array('2 * 2 + 2', 6),
	array('2+ 2 * 2', 6),
	array('(2+ 2) * 2 + 2', 10),
	array('(2+ 3 + 1) / 3 + 7', 9),
	array('2+ 2 * 2 + 2', 8),
	array('729 / 3 / 3 / 3 / 3', 9),
	array('729 / 3 / (3 / 3) / 3', 81),
	array('2 + 1', 3)
);

foreach($tests as $test) {
	$input = $test[0];
	echo "$input = ";
	$result = $test[1];
	$generated_result = calculate($input);
	if ($generated_result == $result) {
		echo "$generated_result passedn";
	} else {
		echo "$generated_result &lt;-- FAILEDn";
	}
}

</pre>
