/*
 *
 * Author  : Aditya Shakya
 * Mail    : adi1090x@gmail.com
 * Github  : @adi1090x
 * Twitter : @adi1090x
 *
 */

configuration {
    lines:							10;
    columns:						2;
    font: 							"Kingthings Trypewriter 2 10";
    bw: 							0;
    location: 						0;
    padding: 						0;
    fixed-num-lines: 				true;
    show-icons: 					false;
    sidebar-mode: 					true;
    separator-style: 				"none";
    hide-scrollbar: 				true;
    fullscreen: 					false;
    fake-transparency: 				false;
    scroll-method: 					1;
    window-format: 					"[{w}] ··· {c} ···   {t}";
    click-to-exit: 					true;
    show-match: 					false;
    combi-hide-mode-prefix: 		false;
    display-window: 				"";
    display-windowcd: 				"";
    display-run: 					"";
    display-ssh: 					"";
    display-drun: 					"";
    display-combi: 					"";
}

@import "colors.rasi"

* {
    background-color:             	@listbgcolor;
    ac: 				@selectedFgActiveItem;
    fg: 				@foreground-tpl;	
    bg: 				@listbgcolor;
    red: 				@windowcolor;
    green: 				@inputbarcolor;
}

window {
    border: 						0px;
    border-color: 					@ac;
    border-radius: 					12px;
    padding: 						20;
    width: 							50%;
    height: 						50%;
}

prompt {
    spacing: 						0;
    border: 						0;
    text-color: 					@fg;
}

textbox-prompt-colon {
    expand: 						false;
    str: 							" ";
    margin:							0px 4px 0px 0px;
    text-color: 					inherit;
}

entry {
    spacing:    					0;
    text-color: 					@fg;
}

case-indicator {
    spacing:    					0;
    text-color: 					@fg;
}

inputbar {
    spacing:    					0px;
    text-color: 					@fg;
    padding:    					1px;
    children: 						[ prompt,textbox-prompt-colon,entry,case-indicator ];
}

mainbox {
    border: 						0px;
    border-color: 					@ac;
    padding: 						6;
}

listview {
    fixed-height: 					0;
    border: 						0px;
    border-color: 					@ac;
    spacing: 						4px;
    scrollbar: 						false;
    padding: 						4px 0px 0px;
}

element {
    border: 						0px;
    padding: 						1px;
}
element-text {
 background-color: inherit;
 text-color: inherit;
}
element normal.normal {
    background-color: 				@bg;
    text-color:       				@fg;
}
element normal.urgent {
    background-color: 				@bg;
    text-color:       				@red;
}
element normal.active {
    background-color: 				@bg;
    text-color:       				@green;
}
element selected.normal {
    background-color: 				@bg;
    text-color:       				@ac;
}
element selected.urgent {
    background-color: 				@bg;
    text-color:       				@red;
}
element selected.active {
    background-color: 				@bg;
    text-color:       				@ac;
}
element alternate.normal {
    background-color: 				@bg;
    text-color:       				@fg;
}
element alternate.urgent {
    background-color: 				@bg;
    text-color:       				@fg;
}
element alternate.active {
    background-color: 				@bg;
    text-color:       				@fg;
}

sidebar {
    border:       					0px;
    border-color: 					@ac;
    border-radius: 					20px;
}

button {
    margin: 						5px;
    padding: 						5px;
    text-color: 					@fg;
    border: 						0px;
    border-radius: 					20px;
    border-color: 					@fg;
}

button selected {
    text-color: 					@fg;
    border: 						3px;
    border-radius: 					20px;
    border-color: 					@ac;
}

scrollbar {
    width:        					4px;
    border:       					0px;
    handle-color: 					@fg;
    handle-width: 					8px;
    padding:      					0;
}

message {
    border: 						0px;
    border-color: 					@ac;
    padding: 						1px;
}

textbox {
    text-color: 					@fg;
}
