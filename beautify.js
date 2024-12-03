/* global $ $create moveFocus */ // dom.js
/* global CodeMirror */
/* global editor */ // util.js
/* global t */ // localization.js
'use strict';

CodeMirror.commands.beautify = cm =>
{
    // using per-section mode when code editor or applies-to block is focused
    const isPerSection = cm.display.wrapper.parentElement.contains(document.activeElement);
    beautify(isPerSection ? [cm] : editor.getEditors(), false);
};

/**
 * @param {CodeMirror[]} scope
 * @param {?} [ui]
 */
async function beautify(scope, ui = true)
{

    // Simplified options without prefs
    const options = {
        // The number of spaces to use for indentation (default is 4 spaces)
        indent_size: 4,

        // The character used for indentation. It can be a space (' ') or a tab ('\t')
        indent_char: ' ',

        // Whether to add a newline after each selector separator (e.g., after commas in CSS rules)
        selector_separator_newline: true,

        // Whether to add a newline before the opening brace of a rule (e.g., '.class {')
        newline_before_open_brace: true,

        // Whether to add a newline after the opening brace of a rule (e.g., '.class {\n')
        newline_after_open_brace: true,

        // Whether to add a newline between properties inside a CSS rule
        newline_between_properties: true,

        // Whether to add a newline before the closing brace of a rule (e.g., '.class {\n  color: red;\n}')
        newline_before_close_brace: true,

        // Whether to add a newline between different CSS rules (e.g., separating rules with a newline)
        newline_between_rules: true,

        // Whether to add space around combinators (e.g., 'div > p')
        space_around_combinator: true,

        // Whether to add space around comparison operators in CSS (e.g., 'a > 1' becomes 'a > 1')
        space_around_cmp: true,

        // Whether to preserve existing newlines in the CSS code
        preserve_newlines: true,

        // Whether to indent conditional blocks (like '@media' rules)
        indent_conditional: true,

        // Whether to indent Mozilla-specific documentation blocks (e.g., '/* @namespace */')
        indent_mozdoc: true,

        // Default options below
        // Whether to use tabs instead of spaces for indentation
        indent_with_tabs: false,

        // Whether to follow editorconfig file rules if one is present
        editorconfig: true,

        // The type of end of line character to use: "\n" (LF) or "\r\n" (CRLF)
        eol: "\n",

        // Whether to ensure the file ends with a newline
        end_with_newline: false,

        // The number of spaces to indent initially (used to offset from the left edge)
        indent_level: 0,

        // The maximum number of newlines to preserve when formatting
        max_preserve_newlines: 10,

        // Whether to add space inside parentheses (e.g., 'func( arg )' becomes 'func( arg )')
        space_in_paren: false,

        // Whether to add space inside empty parentheses (e.g., 'func()' becomes 'func ()')
        space_in_empty_paren: false,

        // Whether to follow JSLint's formatting rules (e.g., placing a space after function names)
        jslint_happy: true,

        // Whether to add a space after anonymous function declarations (e.g., 'function()' becomes 'function ()')
        space_after_anon_function: false,

        // Whether to add a space after named function declarations (e.g., 'function foo()' becomes 'function foo ()')
        space_after_named_function: false,

        // The style of brace formatting: 'collapse' means braces stay on the same line, 'expand' means braces are on a new line
        brace_style: "expand",

        // Whether to un-indent chained method calls (e.g., 'object.method().call()' will be indented like the first call)
        unindent_chained_methods: false,

        // Whether to break chained method calls into separate lines (e.g., 'object.method().call()' becomes separate lines)
        break_chained_methods: false,

        // Whether to keep array indentation consistent across all lines (e.g., 'let arr = [1, 2, 3]' will not change its indentation style)
        keep_array_indentation: false,

        // Whether to unescape strings, which allows characters like "\n" to be displayed instead of escaped
        unescape_strings: false,

        // The maximum number of characters per line before wrapping (0 means no wrapping)
        wrap_line_length: 0,

        // Whether to support e4x (ECMAScript for XML), which is deprecated and not commonly used
        e4x: false,

        // Whether to place the comma before or after the element (e.g., 'a, b' vs. 'a , b')
        comma_first: false,

        // Position of the operator when formatting: 'before-newline' places it before the newline, 'after-newline' places it after
        operator_position: "before-newline",

        // Whether to indent empty lines in the code
        indent_empty_lines: false,

        // Templating system for auto-formatting. It could be used for handling template strings in JS
        templating: ["auto"]
    };

    for(const cm of scope)
    {
        setTimeout(beautifyEditor, 0, cm, options, ui);
    }
}

function beautifyEditor(cm, options, ui)
{
    const pos = options.translate_positions = [].concat.apply([], cm.doc.sel.ranges.map(r => [Object.assign(
    {}, r.anchor), Object.assign(
    {}, r.head)]));
    const text = cm.getValue();
    const newText = css_beautify(text, options);
    if(newText !== text)
    {
        if(!cm.beautifyChange || !cm.beautifyChange[cm.changeGeneration()])
        {
            // clear the list if last change wasn't a css-beautify
            cm.beautifyChange = {};
        }
        cm.setValue(newText);
        const selections = [];
        for(let i = 0; i < pos.length; i += 2)
        {
            selections.push(
            {
                anchor: pos[i],
                head: pos[i + 1]
            });
        }
        const
        {
            scrollX,
            scrollY
        } = window;
        cm.setSelections(selections);
        window.scrollTo(scrollX, scrollY);
        cm.beautifyChange[cm.changeGeneration()] = true;
    }
}

/* exported initBeautifyButton */
function initBeautifyButton(btn, scope)
{
    btn.onclick = btn.oncontextmenu = e =>
    {
        e.preventDefault();
        beautify(scope || editor.getEditors(), e.type === 'click');
    };
}
