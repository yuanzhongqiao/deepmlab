// Some Comment
// blah blah blah

function res = fakeMacroProfileTest()
	function res = nestedFunctionProfileTest()
		res = 21;
	endfunction

	res = nestedFunctionProfileTest() + privateFunctionProfileTest()
endfunction



// blah blah blah
function res = privateFunctionProfileTest()
		res = 21;
endfunction