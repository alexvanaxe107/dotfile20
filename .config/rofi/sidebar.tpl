/**
 * User: qball
 * Copyright: Dave Davenport
 */
* {
    text-color:  #ffeedd;
    background-color:  rgba(0,0,0,0);
    dark: #1c1c1c;
    // Black
    black:       #3d352a;
    lightblack:  #554444;
    //
    // Red
    red:         #cd5c5c;
    lightred:    #cc5533;
    //
    // Green
    green:       #86af80;
    lightgreen:  #88cc22;
    //
    // Yellow
    yellow:      #e8ae5b;
    lightyellow:     #ffa75d;
    //
    // Blue
    blue:      #6495ed;
    lightblue:     #87ceeb;
    //
    // Magenta
    magenta:      #deb887;
    lightmagenta:     #996600;
    //
    // Cyan
    cyan:      #b0c4de;
    lightcyan:     #b0c4de;
    //
    // White
    white:      #bbaa99;
    lightwhite:     #ddccbb;
    //
    // Bold, Italic, Underline
    highlight:     underline bold #ffffff;
    font-default: "Hack 10";
}
window {
    height:   100%;
    width: 30em;
    location: west;
    anchor:   west;
    border:  0px 2px 0px 0px;
    transparency: "real";
    background-color: #bgcolour;
    text-color: @lightwhite;
    font: @font-default;
}

mode-switcher {
    border: 2px 0px 0px 0px;
    background-color: @lightblack;
    padding: 4px;
}
button selected {
    border-color: @lightgreen;
    text-color: @lightgreen;
}
inputbar {
    background-color: #tlightblack;
    text-color: #inputbarfn;
    padding: 9px;
    border: 0px 0px 2px 0px;
    font: "Source Code Pro 18";
}
entry,prompt,case-indicator {
    text-font: inherit;
    text-color:inherit;
}
prompt {
    margin:     0px 0.3em 0em 0em ;
}
mainbox {
    expand: true;
    background-color: #listbgcolor;
    spacing: 1em;
}
listview {
    padding: 0em 0.4em 0em 1em;
    dynamic: false;
    lines: 0;
    background-color: #listbgcolor;
}
element selected  normal {
    background-color: #activeItem;
}
element normal active {
    text-color: @lightblue;
}
element normal urgent {
    text-color: @lightred;
}
element alternate normal {
}
element alternate active {
    text-color: @lightblue;
}
element alternate urgent {
    text-color: @lightred;
}
element selected active {
    background-color: @lightblue;
    text-color: @dark;
}
element selected urgent {
    background-color: @lightred;
    text-color: @dark;
}

error-message {
    expand: true;
    background-color: red;
    border-color: darkred;
    border: 2px;
    padding: 1em;
}
