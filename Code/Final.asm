;===========================================================================;
;===========COMPILE USING TASM - LINK USING TLINK - RUN A MAX CYCLES========;
;===========================================================================;
;	AUTHOR: YANIV KAPLAN                                                    ;
;	                                                                        ;
;	FINAL ASM 8086 PROJECT (CLASS OF 2016-2017)                             ;
;	OSCILLOSCOPE                                                            ;
;	                                                                        ;
;	CREDITS:                                                                ;
;		ALLAH MARIANOVSKY                                                   ;
;		SHMULIK MAUDA.                                                      ;
;       			                       `-.`'.-'                         ;
;                                       `-.        .-'.                     ;
;                                    `-.    -./\.-    .-'                   ;
;                                        -.  /_|\  .-                       ;
;                                    `-.   `/____\'   .-'.                  ;
;                                 `-.    -./.-""-.\.-      '                ;
;                                    `-.  /< (()) >\  .-'                   ;
;                                  -   .`/__`-..-'__\'   .-                 ;
;                                ,...`-./___|____|___\.-'.,.                ;
;                                   ,-'   ,` . . ',   `-,                   ;
;                                ,-'   ________________  `-,                ;
;                                   ,'/____|_____|_____\                    ;
;                                  / /__|_____|_____|___\                   ;
;                                 / /|_____|_____|_____|_\                  ;
;                                ' /____|_____|_____|_____\                 ;
;                              .' /__|_____|_____|_____|___\                ;
;                             ,' /|_____|_____|_____|_____|_\               ;
;,,---''--...___...--'''--.. /../____|_____|_____|_____|_____\ ..--```--..._;
;                           '../__|_____|_____|_____|_____|___\             ;
;      \    )              '.:/|_____|_____|_____|_____|_____|_\            ;
;      )\  / )           ,':./____|_____|_____|_____|_____|_____\           ;
;     / / ( (           /:../__|_____|_____|_____|_____|_____|___\          ;
;    | |   \ \         /.../|_____|_____|_____|_____|_____|_____|_\         ;
; .-.\ \    \ \       '..:/____|_____|_____|_____|_____|_____|_____\        ;
;(=  )\ `._.' |       \:./ _  _ ___  ____ ____ _    _ _ _ _ _  _ ___\       ;
; \ (_)       )       \./  											 \      ;
;  \    `----'         """"""""""""""""""""""""""""""""""""""""""""""""     ;
;   \   ____\__         												    ;
;    \ (=\     \        													;
;     \_)_\     \     												     /  ;
;          \     \                                                        / ;
;           )     )  _                                                _  (  ;
;          (     (,-' `-..__                                    __..-' `-,) ;
;           \_.-''          ``-..____                  ____..-''          ``;
;            `-._                    ``--...____...--''                    _;
;                `-.._                                                _..-' ;
;                     `-..__         	SHMULIK KNOWS ALL      __..-'       ;
;                           ``-..____                  ____..-''            ;
;                                    ``--...____...--''                     ;
;                                                                           ;
;===========================================================================;
;========= BASE LENGTH: LINES = 176, LENGTH = 9,226 ========================;
;========= END LENGTH : LINE =     , LENGTH =       ========================;
;===========================================================================;
                                                                            ;
                                                                            ;
;===========================================================================;
;========================================= MACROS ==========================;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
DRAW_WELCOME MACRO                                                          ;
LOCAL @@_WAIT                                                               ;
;=============================                                              ;
;	DRAWS THE WELCOME SCREEN                                                ;
;=============================                                              ;
                                                                            ;
	MOV CX, OFFSET ANAL                                                     ;
	FINAL 220, 400, CX														;DRAW TITLE
	                                                                        ;
	MOV CX, OFFSET PRE														;DRAW INSTRUCTIONS
	FINAL 70, 800, CX                                                       ;
	                                                                        ;
@@_WAIT	:                                                                   ;
	MOV AH, 0H																;WAIT UNTILL A KEY PRESS IS REGISTERD
	INT 16H	                                                                ;
	                                                                        ;
	IN AL, 64H																;CHECK KEYBOARD BUFFER STATUS	
	CMP AL, 10B																;10B - BUFFER IS EMPTY
	JE @@_WAIT                                                              ;
                                                                            ;
MENU_SERVICE CLEAR_ALL														;CLEAR THE ENTIRE SCREEN
                                                                            ;
ENDM                                                                        ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
DRAW_TUTORIAL MACRO                                                         ;
;=============================                                              ;
;	DRAW THE TUTORIAL                                                       ;
;=============================                                              ;
                                                                            ;
	MOV CX, OFFSET DEF														;WHAT IS AN OSCILLOSCOPE
	FINAL 290,400  , CX                                                     ;
	                                                                        ;
	PAUSE_FOR 17															;DELAY
	                                                                        ;
	MOV CX, OFFSET VPDD														;VOLTS PRE DIVISION INSTRUCTIONS
	FINAL 15,135  , CX                                                      ;
	                                                                        ;
	PAUSE_FOR 17                                                            ;
	                                                                        ;
	MOV CX, OFFSET TIME														;TIME BASE INSTRUCTIONS
	FINAL 250,40  , CX                                                      ;
	                                                                        ;
	PAUSE_FOR 17                                                            ;
	                                                                        ;
	MOV CX, OFFSET AN														;ADD TO NEW OR ADD TO EXISTING
	FINAL 550, 920, CX                                                      ;
	                                                                        ;
	PAUSE_FOR 10                                                            ;
	                                                                        ;
	MOV CX, OFFSET WHAT														;WHAT TO INPUT
	FINAL 950, 955, CX                                                      ;
	                                                                        ;
                                                                            ;
ENDM                                                                        ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
CLEAR_VPD_OR_TB MACRO X, Y                                                  ;
;=============================                                              ;
;	CLEAR THE VOLTS PER DIVISION OR TIME                                    ;
;	BASE, SO THAT THE NEW INPUT IS WRITTEN                                  ;
;	CORRECTLY                                                               ;
;=============================                                              ;
;|GETS AN (X,Y) LOCATION OF WHERE THE VPD                                   ;
;|AND TB ARE                                                                ;
;=============================                                              ;
	MOV BX, OFFSET CLEAR_TB_AND_VPD                                         ;
	MOV CX, X                                                               ;
	PUSH CX                                                                 ;
	MOV CX, Y                                                               ;
	PUSH CX                                                                 ;
	MOV CX, 0                                                               ;
	PUSH CX                                                                 ;
	PUSH BX                                                                 ;
	MOV CX, '$'                                                             ;
	PUSH CX                                                                 ;
	CALL WRITE_AT_LOCATION													;WRITE SPACES TO THE LOCATION OF THE TB OR VPD
ENDM                                                                        ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
CLEAR_SINES_ARRAY MACRO                                                     ;
LOCAL @@LOOPDI                                                              ;
;=============================                                              ;
;	CLEAR THE ARRAY THAT HOLDS ALL                                          ;
;	CURRENTLY CALCUATED SINES                                               ;
;=============================                                              ;
                                                                            ;
	PUSH BX CX 																;
	                                                                        ;
	MOV BX, OFFSET SINES_ARRAY												;
	MOV CX, 30                                                              ;
@@LOOPDI:                                                                   ;
	MOV [WORD PTR BX], 01111H                                               ;
	ADD BX, 2																;NEED TO ADD 2 BECAUSE SIZE OF ELEMENTS IS A WORD
	LOOP @@LOOPDI                                                           ;
	                                                                        ;
	POP CX BX                                                               ;
ENDM                                                                        ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
PLACE_SINE_ON_BLANK MACRO                                                   ;
;=============================                                              ;
;	DOES EVERYTHING REQUIRED SO THAT                                        ;
;	THE SINE WHICH THE USER INPUTED IS PLACED                               ;
;	ON A CLEAR SCREEN                                                       ;
;=============================                                              ;
	CLEAR_SCREEN_ARRAY                                                      ;
	MOV [CURRENT_SINE], 0                                                   ;
	CLEAR_SINES_ARRAY                                                       ;
ENDM                                                                        ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
INPUT_SINE MACRO                                                            ;
;=============================                                              ;
;	TAKE USER INPUT FOR THE SINE                                            ;
;=============================                                              ;
	DRAW_OPTIONS                                                            ;
	                                                                        ;
	MOV CX, OFFSET FILENAME5										        ;
	FINAL 1016 ,958 , CX                                                    ;
	                                                                        ;
	INPUT_FROM_USER 127, 59													;DIVIDEND OF AMPLITUDE	
	INPUT_FROM_USER 127, 61													;DIVISOR OF AMPLITUDE
	INPUT_FROM_USER 148, 60													;FREQUENCY
	POP BX                                                                  ;
	POP DX                                                                  ;
	POP AX                                                                  ;
	                                                                        ;
	NEW_SINE BX, AX, DX , 1													;CALCULATE THE SINE THAT WE INPUTED AND STORE IT
																			;IN THE SINE ARRAY
	DRAW_MAIN                                                               ;
	WRITE_VPD_AND_TB                                                        ;
	                                                                        ;
ENDM                                                                        ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
INPUT_TB MACRO                                                              ;
;=============================                                              ;
;	TAKE USER INPUT FOR THE TIME BASE                                       ;
;=============================                                              ;
                                                                            ;
	MOV CX, OFFSET DN                                                       ;
	FINAL 150, 7, CX                                                        ;
                                                                            ;
	CLEAR_VPD_OR_TB 16,5                                                    ;
	INPUT_FROM_USER 9, 10                                                   ;
	POP AX                                                                  ;
	MOV [WORD PTR TB], AX                                                   ;
	WRITE_VPD_AND_TB												        ;
	MENU_SERVICE CLEAR_VPD_INPUT										    ;
	DRAW_MAIN                                                               ;
	RE_CALCULATE															;WHEN WE INPUT A NEW TIME BASE WE MUST RE CALCUATE ALL CURRE
ENDM																		;SINES
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
RE_CALCULATE MACRO                                                          ;
LOCAL @@JUSTN, @@LOOPI                                                      ;
;=============================                                              ;
;	RE CALCUATE ALL CURRENT SINES                                           ;
;=============================                                              ;
	CLEAR_SCREEN_ARRAY														;
	                                                                        ;
	CMP [CURRENT_SINE], 0													;CHECK IF THERE IS SOMETHING TO RECALCULATE
	JE @@JUSTN                                                              ;
	                                                                        ;
	PUSH [CURRENT_SINE]														;WE MUST MAKE SURE THAT WE DON'T CHANGE THIS
@@LOOPI:                                                                    ;
	DEC [CURRENT_SINE]                                                      ;
	TAKE_INFO [CURRENT_SINE]	                                            ;
	NEW_SINE AX, DX, DI, 0													;TAKE THE AMPLITUDE AND FREQUENCY FROM SINE ARRAY
	CMP [CURRENT_SINE], 0													;AND USE IT TO CALCULATE THAT SPECIFIC SINE WITHOUT
	JNE @@LOOPI																;STORING IT AGAIN IN THE SINE ARRAY
	POP [CURRENT_SINE]                                                      ;
@@JUSTN:                                                                    ;
ENDM                                                                        ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
INPUT_VPD MACRO                                                             ;
;=============================                                              ;
;	TAKE USER INPUT FOR THE VOLTS PER DIVISION                              ;
;=============================                                              ;
	CLEAR_VPD_OR_TB 0, 4                                                    ;
	                                                                        ;
	MOV CX, OFFSET DN                                                       ;
	FINAL 20, 7, CX                                                         ;
	                                                                        ;
	INPUT_FROM_USER 9, 10                                                   ;
	POP AX                                                                  ;
	MOV [VPD], AX                                                           ;
	WRITE_VPD_AND_TB                                                        ;
	MENU_SERVICE CLEAR_VPD_INPUT                                            ;
	DRAW_MAIN                                                               ;
ENDM	                                                                    ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
WRITE_AT_LOC MACRO WHAT, X, Y                                               ;
LOCAL @@NO_MIN                                                              ;
;=============================                                              ;
;	WRITE SOMETHING AT A SPECIFIC LOCATION                                  ;
;	IF WHAT WE ARE WRITING IS NEGATIVE, DRAW A '-'                          ;
;	BEFORE IT                                                               ;
;=============================                                              ;
;|GETS THE VALUE TO WRITE, AND THE (X,Y) OF                                 ;
;|WHERE TO WRITE IT                                                         ;
;=============================                                              ;
	PUSH CX BX                                                              ;
	                                                                        ;
	MOV CX, WHAT                                                            ;
	PUSH CX                                                                 ;
	MOV CX, 0                                                               ;
	PUSH CX                                                                 ;
	MOV CX, 10                                                              ;
	PUSH CX                                                                 ;
	MOV CX, OFFSET ENDTHING                                                 ;
	PUSH CX                                                                 ;
	MOV CX, 7                                                               ;
	PUSH CX                                                                 ;
	                                                                        ;
	CALL PRINT_INFO															;PRINT INFOR IS A FUNCTION THAT
	POP BX																	;CALCULATED EXACTLY HOW MANY SPACED ARE NEEDED
	CMP [NEGATIVE], 1														;SO THAT THE NUMBER THAT WE ARE WRITING IS ALWAYS
	JNE @@NO_MIN															;CENTERED
	SUB BX, 1                                                               ;
	MOV [BYTE PTR BX], '-'													;IF NEGATIVE IS TRUE, GO BACK ONE SPOT AND WRITE A '-'
@@NO_MIN:                                                                   ;
	MOV CX, X                                                               ;
	PUSH CX                                                                 ;
	MOV CX, Y                                                               ;
	PUSH CX                                                                 ;
	MOV CX, 0                                                               ;
	PUSH CX                                                                 ;
	PUSH BX                                                                 ;
	MOV CX, '$'                                                             ;
	PUSH CX                                                                 ;
	CALL WRITE_AT_LOCATION													;WRITE THE RESULT (INCLUDING SPACES AND THE MINUS SIGN)
																			;AT THE LOCATION GIVEN
	POP BX CX                                                               ;
ENDM										                                ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
INPUT_FROM_USER MACRO X, Y                                                  ;
LOCAL @@_WAIT, @@_EXIT, @@_NEG, @@_REAL_EXIT, @@_POS                        ;
;=============================                                              ;
;	TAKE USER INPUT                                                         ;
;=============================                                              ;
;|GET THE (X,Y) LOCATION OF WHERE TO ECHO THE                               ;
;|INPUT                                                                     ;
;=============================                                              ;
	                                                                        ;
	XOR AX, AX                                                              ;
	MOV CX, 10                                                              ;
@@_WAIT:                                                                    ;
	PUSH AX                                                                 ;
	MOV AH, 7                                                               ;
	INT 21H																	;TAKE KEY, NO ECHO
	CMP AL, 0DH																;IS THE KEY ENTER? IF SO, STOP TAKING INPUT
	JE @@_EXIT															    ;
	CMP AL, 2DH																;IS THE KEY '-'? IF SO, THE NUMBER WE ARE INPUTING IS NEGATIVE
	JE @@_NEG	                                                            ;
	SUB AL, 30H																;GET THE NUMBER, NOT THE ASCII SYMOBOL
	MOV BL, AL                                                              ;
	POP AX                                                                  ;
	MUL CX																	;
	XOR BH, BH                                                              ;
	ADD AX, BX																;THIS IS HOW WE MAKE A NUMBER OUT OF SEPERATE DIGITS:
																			;EVERY TIME A NEW DIGIT IS TAKEN FROM THE USER MULTIPLY THE 
																			;CURRENT NUMBER BY 10, THEM ADD THE DIGIT TO THE NUMBER.
	                                                                        ;
	WRITE_AT_LOC AX, X, Y													;NOW ECHO THE INPUT
	                                                                        ;
	JMP @@_WAIT                                                             ;
@@_EXIT:                                                                    ;
	POP AX                                                                  ;
	JMP @@_REAL_EXIT                                                        ;
@@_NEG:                                                                     ;
	POP AX						                                            ;
	MOV [NEGATIVE], 1														;IF WE GOT '-', "REMEMBER" IT, AND KEEP TAKING INPUT
	JMP @@_WAIT                                                             ;
@@_REAL_EXIT:                                                               ;
	CMP [NEGATIVE], 1														;
	JNE @@_POS                                                              ;
	NEG AX																	;
@@_POS:                                                                     ;
	MOV [NEGATIVE], 0														;MUST MAKE SURE TO RESET [NEGATIVE]
	PUSH AX                                                                 ;
ENDM	                                                                    ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
CLEAR_SCREEN_ARRAY MACRO                                                    ;
LOCAL @@LOOPDI                                                              ;
;=============================                                              ;
;	CLEAR THE SCREEN FROM PREVIOUSLY CALCULATED                             ;
;	SINES                                                                   ;
;=============================                                              ;
	PUSH BX CX                                                              ;
	                                                                        ;
	MOV BX, OFFSET SCREEN_ARRAY                                             ;
	MOV CX, SCREEN_SIZE_THING												;THIS IS A CONSTANT WHICH HOLDS THE LENGTH OF THE SCREEN
@@LOOPDI:                                                                   ;
	MOV [WORD PTR BX], 0                                                    ;
	ADD BX, 2                                                               ;
	LOOP @@LOOPDI                                                           ;
	                                                                        ;
	POP CX BX                                                               ;
ENDM                                                                        ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
TAKE_INFO MACRO SINE                                                        ;
;=============================                                              ;
;	TAKE INFROMATIN FORM LOCATION IN SINE ARRAY                             ;
;=============================                                              ;
;|GETS THE NUMBER OF THE SINE THAT WE WANT THE INFO OF                      ;
;=============================                                              ;
	PUSH CX                                                                 ;
                                                                            ;
	PUSH CX                                                                 ;
	MOV CX, SINE                                                            ;
	PUSH CX                                                                 ;
	MOV CX, OFFSET SINES_ARRAY                                              ;
	PUSH CX                                                                 ;
	CALL TAKE_FROM_SINE_ARRAY												;SEE FUNCTION'S DOCUMENTATION
	POP AX                                                                  ;
	POP DX                                                                  ;
	POP DI                                                                  ;
	                                                                        ;
	POP CX                                                                  ;
ENDM                                                                        ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
PAUSE_FOR MACRO TIME                                                        ;
;=============================                                              ;
;	DELAY                                                                   ;
;=============================                                              ;
;| GET AMOUNT OF TIME (IN MILISECONDS)                                      ;
;=============================                                              ;
	PUSH CX                                                                 ;
	MOV CX, TIME                                                            ;
	PUSH CX                                                                 ;
	CALL DELAY																;SEE FUNCTION'S DOCUMENTATION
	POP CX                                                                  ;
ENDM                                                                        ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
WRITE_VPD_AND_TB MACRO                                                      ;
	PUSH CX BX                                                              ;
	                                                                        ;
	PUSH [VPD]                                                              ;
	MOV CX, 0                                                               ;
	PUSH CX                                                                 ;
	MOV CX, 10                                                              ;
	PUSH CX                                                                 ;
	MOV CX, OFFSET ENDTHING                                                 ;
	PUSH CX                                                                 ;
	MOV CX, 7                                                               ;
	PUSH CX                                                                 ;
	                                                                        ;
	CALL PRINT_INFO                                                         ;
	POP BX                                                                  ;
	                                                                        ;
	MOV CX, 0                                                               ;
	PUSH CX                                                                 ;
	MOV CX, 4                                                               ;
	PUSH CX                                                                 ;
	MOV CX, 0                                                               ;
	PUSH CX                                                                 ;
	PUSH BX                                                                 ;
	MOV CX, '$'                                                             ;
	PUSH CX                                                                 ;
	CALL WRITE_AT_LOCATION													;WRITE THE VPD
	                                                                        ;
                                                                            ;
	PUSH [WORD PTR TB]                                                      ;
	PUSH [WORD PTR TB+2]                                                    ;
	MOV CX, 10                                                              ;
	PUSH CX                                                                 ;
	MOV CX, OFFSET ENDTHING                                                 ;
	PUSH CX                                                                 ;
	MOV CX, 7                                                               ;
	PUSH CX                                                                 ;
	                                                                        ;
	CALL PRINT_INFO                                                         ;
	POP BX                                                                  ;
	                                                                        ;
	MOV CX, 17                                                              ;
	PUSH CX                                                                 ;
	MOV CX, 5                                                               ;
	PUSH CX                                                                 ;
	MOV CX, 0                                                               ;
	PUSH CX                                                                 ;
	PUSH BX                                                                 ;
	MOV CX, '$'                                                             ;
	PUSH CX                                                                 ;
	CALL WRITE_AT_LOCATION													;WRITE THE TIME BASE
	                                                                        ;
	POP BX CX                                                               ;
ENDM                                                                        ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
CLEAR_THING MACRO                                                           ;
LOCAL @@LOPP                                                                ;
;=============================                                              ;
;	CLEAR "THING" WHICH IS USED                                             ;
; 	AS A BUFFER BEFORE WRITING INPUTED VALUES                               ;
;=============================                                              ;
	PUSH BX                                                                 ;
	                                                                        ;
	MOV BX, 6                                                               ;
@@LOPP:                                                                     ;
	MOV [BYTE PTR THING+BX], ' '                                            ;
	DEC BX                                                                  ;
	CMP BX, 0                                                               ;
	JNE @@LOPP                                                              ;
	                                                                        ;
	POP BX                                                                  ;
ENDM                                                                        ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
PRINT_WITH_VPD MACRO                                                        ;
LOCAL @@A_SCREEN1                                                           ;
;=============================                                              ;
;	PRINT THE VALUES IN THE SCREEN ARRAY                                    ;
;	WHICH ARE THE VALUES OF THE CALCUATED SINES                             ;
;	WHILE MULTIPLYING EACH ONE BY THE VPD VALUE DIVIDED BY 256              ;
;=============================                                              ;
PUSH CX                                                                     ;
                                                                            ;
MENU_SERVICE CLEAR_SINE                                                     ;
                                                                            ;
MOV CX, SCREEN_SIZE_THING                                                   ;
@@A_SCREEN1:                                                                ;
	                                                                        ;
	PUSH CX                                                                 ;
	                                                                        ;
	PUSH [X]                                                                ;
	PUSH [SCREEN_SIZE]                                                      ;
	                                                                        ;
	MOV CX, [VPD]                                                           ;
	PUSH CX                                                                 ;
	                                                                        ;
	MOV CX, OFFSET SCREEN_ARRAY                                             ;
	ADD CX, [CURRENT_LOC]                                                   ;
	PUSH CX                                                                 ;
	                                                                        ;
	CALL PRINTE_AT_LOC_AND_VPD												;SEE FUNCTION'S DOCUMENTATION
	INC [X]                                                                 ;
	ADD [CURRENT_LOC], 2                                                    ;
	                                                                        ;
	POP CX                                                                  ;
	                                                                        ;
	LOOP @@A_SCREEN1                                                        ;
	                                                                        ;
	MOV [X], 0                                                              ;
	MOV [CURRENT_LOC], 0                                                    ;
	                                                                        ;
	POP CX                                                                  ;
	                                                                        ;
ENDM                                                                        ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
NEW_SINE MACRO FREQEI, AMPEI, AMPEI2, STORE_OR_NOT                          ;
LOCAL @@A_SCREEN, @@DONT                                                    ;
;=============================                                              ;
;	ADD THE VALUES OF A GIVEN SINE WAVE TO THE CURRENT SCREEN               ;
; 	IF STORE_OR_NOT IS 1, ALSO STORE THE SINE IN THE SINE ARRAY             ;
;=============================                                              ;
;|GETS THE FREQUENCY, THE AMPLITUDE                                         ;
;|AND WHETER TO STORE THE SINE OR NOT (O OR 1)                              ;
;=============================                                              ;
	MOV CX, STORE_OR_NOT                                                    ;
	CMP CX, 0                                                               ;
	JE @@DONT                                                               ;
	                                                                        ;
	PUSH [CURRENT_SINE]                                                     ;
	MOV CX, OFFSET SINES_ARRAY                                              ;
	PUSH CX                                                                 ;
	MOV CX, FREQEI                                                          ;
	PUSH CX                                                                 ;
	XOR CX, CX                                                              ;
	MOV CX, AMPEI                                                           ;
	PUSH CX                                                                 ;
	MOV CX, AMPEI2                                                          ;
	PUSH CX                                                                 ;
	                                                                        ;
	CALL PUTIN_SINE_ARRAY													;SEE FUNCTION'S DOCUMENTATION
	                                                                        ;
	INC [CURRENT_SINE]                                                      ;
	CMP [CURRENT_SINE], 9													;CAN'T STORE MORE THAN 10 SINES IN THE SINE ARRAY
	JLE @@DONT																;(COUNTING BEGINS AT 0)
	                                                                        ;
	MOV [CURRENT_SINE], 9                                                   ;
	                                                                        ;
@@DONT:	                                                                    ;
	MOV CX, SCREEN_SIZE_THING                                               ;
	MOV [FREQUENCY], FREQEI                                                 ;
	MOV [PRE_AMP], AMPEI                                                    ;
	MOV [AMP], AMPEI2                                                       ;
	                                                                        ;
@@A_SCREEN:                                                                 ;
                                                                            ;
	PUSH CX                                                                 ;
	CALL CALCULATE_SCREEN													;SEE FUNCTION'S DOCUMENTATION
	POP CX                                                                  ;
	                                                                        ;
	LOOP @@A_SCREEN															;
	                                                                        ;
	MOV [X], 0                                                              ;
	MOV [CURRENT_LOC], 0                                                    ;
ENDM                                                                        ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
SQUISH_TO_DOUBLE_WORD MACRO                                                 ;
;=============================                                              ;
;	USED TO CONVERT 2 WORDS AND A BYTE TO 2 WORDS                           ;
;   (ONLY WHEN THE FIRST BYTE DOESN'T MATTER)                               ;
;=============================                                              ;
	SHR DX, 1                                                               ;
	RCR CX, 1                                                               ;
	RCR BX, 1                                                               ;
                                                                            ;
	SHR DX, 1                                                               ;
	RCR CX, 1                                                               ;
	RCR BX, 1                                                               ;
                                                                            ;
	SHR DX, 1                                                               ;
	RCR CX, 1                                                               ;
	RCR BX, 1                                                               ;
                                                                            ;
	SHR DX, 1                                                               ;
	RCR CX, 1                                                               ;
	RCR BX, 1																;MOVE 4 FIRST BITS OF DL INTO 4 LAST BITS OF CL, THEN 
ENDM																		;4 FIRST BITS OF CL INTO 4 LAST BITS OF BH SO THAT THE 
																			;FIRST 4 BITS OF BL ARE ERASED.
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
MENU_SERVICE MACRO SPECIFIC_MENU                                            ;
;=============================                                              ;
;	DRAW A MENU                                                             ;
;=============================                                              ;
	PUSH CX                                                                 ;
	                                                                        ;
	MOV CX, OFFSET SPECIFIC_MENU                                            ;
	PUSH CX                                                                 ;
	CALL PRINT_STRING														;SEE FUNCTION'S DOCUMENTATION
	                                                                        ;
	POP CX                                                                  ;
ENDM                                                                        ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
INC_DOUBLE_WORD MACRO OFFSET_OF_IT, OFFSET_OF_ITP2                          ;
;=============================                                              ;
;	AS YOU CANT USE THE INC OPERATION ON A DOUBLE WORD,                     ;
;	THIS WILL DO IT                                                         ;
;=============================                                              ;
;| GETS BOTH PARTS OF THE DOUBLE WORD TO INC                                ;
;=============================                                              ;
PUSH CX                                                                     ;
MOV CX, OFFSET_OF_IT                                                        ;
PUSH CX                                                                     ;
MOV CX, OFFSET_OF_ITP2                                                      ;
PUSH CX                                                                     ;
CALL INC_DD																	;SEE FUNCTION'S DOCUMENTATION
POP CX                                                                      ;
ENDM                                                                        ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
DO MACRO                                                                    ;
;=============================                                              ;
;	READ DATA FROM FILE AT CURRENTLOC OFFSET                                ;
; 	FOR EXAMPLE: READ DATA IN THE 10TH LOCATION IN THE FILE                 ;
;=============================                                              ;
PUSH CX AX                                                                  ;
	MOV CX, OFFSET HANDLE                                                   ;
	PUSH CX                                                                 ;
	MOV CX, OFFSET READ_DATA                                                ;
	PUSH CX                                                                 ;
	CALL READ_FROM_FILE														;FUNCTION READS DATA FROM FILE AT OFFSET [CURRENTLOC], 
	MOV CX, OFFSET CURRENTLOC												;THEN STORES THE DATA IN READ_DATA
	MOV AX, OFFSET CURRENTLOC+2                                             ;
	INC_DOUBLE_WORD CX, AX													;ONCE YOU READ FROM THE CURRENT LOCATION, INCREMENT IT
POP AX CX                                                                   ;
ENDM                                                                        ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
FINAL MACRO START_X, START_Y, OFFSET_FILNAME                                ;
LOCAL @@NO, @@LOOP, @@PRINT, @@DONE, @@LINE                                 ;
;=============================                                              ;
;	DRAW IMAGE PIXEL BY PIXEL FROM A CERTAIN FILE                           ;
; 	CONTAINING AN ARRAY OF 0s AND 1s                                        ;
;=============================                                              ;
;|GETS (X,Y) LOCATION FROM WHICH IT NEEDS TO START PRINTING                 ;
;|AND THE OFFSET OF A FILE NAME TO READ FROM                                ;
;=============================                                              ;
	PUSH CX BX                                                              ;
	                                                                        ;
	MOV [GRAPH_X], START_X                                                  ;
	MOV [GRAPH_Y], START_Y                                                  ;
	                                                                        ;
	                                                                        ;
	MOV CX, OFFSET_FILNAME                                                  ;
	PUSH CX                                                                 ;
	                                                                        ;
	MOV CX, OFFSET HANDLE                                                   ;
	PUSH CX                                                                 ;
	                                                                        ;
	CALL OPEN_FILE                                                          ;
@@LOOP:                                                                     ;
	DO																		;READ DATA FROM LOCATION
	MOV BX, OFFSET READ_DATA												;
	@@PRINT:                                                                ;
	                                                                        ;
	CMP [BYTE PTR BX], '1'													;IF THE CURRENT DATA IS 1, DRAW THE PIXEL
	JNE @@NO                                                                ;
	                                                                        ;
	PUSH [GRAPH_Y]                                                          ;
	PUSH [GRAPH_X]                                                          ;
	CALL DRAW_FUNCTION                                                      ;
	                                                                        ;
	INC [GRAPH_X]                                                           ;
	                                                                        ;
	JMP @@LOOP                                                              ;
	                                                                        ;
	@@NO:                                                                   ;
	                                                                        ;
	CMP [BYTE PTR BX], '0'													;IF IT IS 0, SKIP THE CURRENT X, STAY ON SAME Y
	JNE @@LINE                                                              ;
	                                                                        ;
	INC [GRAPH_X]                                                           ;
	                                                                        ;
	JMP @@LOOP                                                              ;
	                                                                        ;
	@@LINE:                                                                 ;
	                                                                        ;
	CMP [BYTE PTR BX], '$'													;IF DATA IS A DOLLAR SIGN, GO DOWN ONE LINE, MAKE SURE
	JNE @@DONE																;TO RESET THE X TO THE BEGINNING OF THE LINE SO THAT THE IMAGE
																			;IS ALIGNED
	INC [GRAPH_Y]                                                           ;
	MOV [GRAPH_X], START_X                                                  ;
	                                                                        ;
	JMP @@LOOP                                                              ;
	                                                                        ;
	@@DONE:                                                                 ;
	                                                                        ;
	CMP [BYTE PTR BX], '#'													;IF DATA IS NUMBER SIGN, WE GOT TO THE END OF THE FILE
	JNE @@LOOP																;HOORAY! 
	                                                                        ;
	CALL CLOSE_FILE															;THIS WILL TAKE CARE OF RESETTING EVERYTHING: THE HANDLE &
	POP BX CX																;											  THE CURRENT LOCATION IN THE FILE
ENDM                                                                        ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
DRAW_MAIN MACRO                                                             ;
;=============================                                              ;
;	USED TO DRAW THE ENTIRE MAIN MENU                                       ;
;=============================                                              ;
	PUSH CX                                                                 ;
	MENU_SERVICE MENU                                                       ;
	MENU_SERVICE CLEAR_FOR_MAIN                                             ;
	                                                                        ;
	MOV CX, OFFSET FILENAME													;
	FINAL 0, 40, CX                                                         ;
	                                                                        ;
	MOV CX, OFFSET FILENAME1                                                ;
	FINAL 0, 920, CX                                                        ;
	                                                                        ;
	MOV CX, OFFSET FILENAME2                                                ;
	FINAL 30, 935, CX                                                       ;
	                                                                        ;
	MOV CX, OFFSET FILENAME3                                                ;
	FINAL 630, 890, CX                                                      ;
	                                                                        ;
	MOV CX, OFFSET AN                                                       ;
	FINAL 550, 920, CX                                                      ;
	                                                                        ;
	POP CX                                                                  ;
ENDM                                                                        ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
DRAW_OPTIONS MACRO                                                          ;
;=============================                                              ;
;	DRAW THE OPTIONS MENU                                                   ;
;=============================                                              ;
PUSH CX                                                                     ;
	MENU_SERVICE CLEAR                                                      ;
	                                                                        ;
	MOV CX, OFFSET FILENAME4                                                ;
	FINAL 630, 930, CX                                                      ;
	                                                                        ;
	MOV CX, OFFSET FILENAME1                                                ;
	FINAL 0,920,CX                                                          ;
POP CX                                                                      ;
ENDM                                                                        ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
;====================================== END OF MACROS ======================;
;===========================================================================;
                                                                            ;
                                                                            ;
IDEAL                                                                       ;
MODEL SMALL                                                                 ;
STACK 100H                                                                  ;
                                                                            ;
                                                                            ;
;===========================================================================;
;=========================================== EQU ===========================;
SCREEN_SIZE_THING EQU 1260                                                  ;
;======================================= END OF EQU ========================;
;===========================================================================;
                                                                            ;
DATASEG                                                                     ;
                                                                            ;
;===========================================================================;
;======================== THIS IS THE DATASEGMENT, DON'T PUT CODE HERE =====;
;========================================= DATA ============================;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
NEGATIVE DB 0																;USED TO CHECK IF THE INPUT IS NEGATIVE
CURRENT_LOC DW 0															;?????????
                                                                            ;
SINES_ARRAY DW 30 DUP (1111H)												;ARRAY OF ALL SINES ON SCREEN
END_OF_SINES_ARRAY DB '#'                                                   ;
CURRENT_LOCATION_IN_SINE_ARRAY DW 0											;NOT USED
CURRENT_SINE DW 0 ;0-9														;NUMBER OF THE SINE WHICH WILL BE INPUTED
                                                                            ;
                                                                            ;
FREQUENCY DW  200															;
TB DD 10																	;TIME BASE
X DW 0	                                                                    ;
PRE_AMP DW 1                                                                ;
AMP DW 1 																	;AMPLITUDE IS PRE_AMP:AMP
SCREEN_SIZE DW 512															;SIZE OF HALF OF THE SCREEN
                                                                            ;
VPD DW 340																	;VOLTS PER DIVISON
CURRENTLOC DD 0																;USED FOR READING FROM FILE
	                                                                        ;
GRAPH_X DW 0                                                                ;
GRAPH_Y DW 40                                                               ;
                                                                            ;
FILENAME DB '1.TXT',0                                                       ;
FILENAME1 DB '3.TXT',0                                                      ;
FILENAME2 DB '2.TXT',0                                                      ;
FILENAME3 DB '4.TXT', 0                                                     ;
FILENAME4 DB '5.TXT', 0                                                     ;
FILENAME5 DB '6.TXT', 0                                                     ;
AN DB 'AN.TXT',0                                                            ;
ANAL DB 'ANAL.TXT',0                                                        ;
DEF DB 'DEF.TXT',0                                                          ;
PRE DB 'PRE.TXT',0                                                          ;
TIME DB 'TIME.TXT',0                                                        ;
VPDD DB 'VPD.TXT',0                                                         ;
WHAT DB 'WHAT.TXT',0                                                        ;
DN DB 'DN.TXT',0															;FILE NAMES
                                                                            ;
HANDLE   DW ?																;HANDLE OF CURRENT OPENED FILE
READ_DATA DB ?																;
                                                                            ;
THING DB 7 DUP (32) 														;BUFFER FOR ECHOING THE INPUT
ENDTHING DB '$'                                                             ;
                                                                            ;
LOOK_UP_TABLE1 DW 0  ,2  ,3  ,5  ,7  ,8  ,10 ,12 ,13 ,15 ,17 ,18 ,20 ,22 ,23;
			   DW 25 ,26 ,28, 30 ,31 ,33 ,34 ,36 ,38 ,39 ,41 ,42 ,44 ,45 ,47;
			   DW 48 ,49 ,51 ,52 ,54 ,55, 56 ,58 ,59 ,60 ,62 ,63 ,64 ,65 ,67;
			   DW 68 ,69 ,70 ,71 ,72 ,74 ,75 ,76 ,77, 78 ,79 ,80 ,81 ,81 ,82;
			   DW 83 ,84 ,85 ,86 ,86 ,87 ,88 ,88 ,89 ,90 ,90 ,91, 91 ,92 ,92;
			   DW 93 ,93 ,94 ,94 ,94 ,95 ,95 ,95 ,95 ,95 ,96 ,96 ,96 ,96 ,96;
			   DW 96 ,96 ,96 ,96 ,96 ,96 ,95 ,95 ,95 ,95 ,95 ,94 ,94 ,94 ,93;
			   DW 93 ,92 ,92, 91 ,91 ,90 ,90 ,89 ,88 ,88 ,87 ,86 ,86 ,85 ,84;
			   DW 83 ,82 ,81 ,81 ,80 ,79, 78 ,77 ,76 ,75 ,74 ,72 ,71 ,70 ,69;
			   DW 68 ,67 ,65 ,64 ,63 ,62 ,60 ,59 ,58, 56 ,55 ,54 ,52 ,51 ,49;
			   DW 48 ,47 ,45 ,44 ,42 ,41 ,39 ,38 ,36 ,34 ,33 ,31, 30 ,28 ,26;
			   DW 25 ,23 ,22 ,20 ,18 ,17 ,15 ,13 ,12 ,10 ,8  ,7  ,5  ,3  ,2 ;
			   DW 0															;ARRAY OF APROXIMATE VALUES OF 96*Sin(x)
                                                                            ;
			                                                                ;
FREE_SPACE DB ?									                            ;
							                                                ;
SCREEN_ARRAY DW (SCREEN_SIZE_THING) DUP (0)									;ARRAY THAT HOLDS ALL VALUES OF THE CALCULATED SINES
END_OF_SCREEN_ARRAY DB '#'                                                  ;
                                                                            ;
                                                                            ;
BUFFER DB 4 DUP (0)															;NOT REALLY REQUIRED
                                                                            ;
                                                                            ;
MENU 		DB 3 DUP (10,13)												;MAIN MENU
			DB '                TIME BASE',10,13                            ;
			DB 1 DUP (10,13)                                                ;
			DB '                 '                                          ;
			DB 1 DUP (10,13)                                                ;
			DB '  256', 10, 13                                              ;
			DB '              10^-6 SECONDS ','$'                           ;
                                                                            ;
CLEAR 		DB 9 DUP (10,13)												;______
			DB 55 DUP (180 DUP (' ')), '$' 									;  ||
CLEAR_SINE  DB 9 DUP (10,13)												;  ||
			DB 41 DUP (180 DUP (' ')), '$'									;  ||
CLEAR_VPD_INPUT DB 2 DUP (180 DUP (' '))									;  ||
				DB 8 DUP (10, 13)											;  ||
				DB 30 DUP (' '), '$'										;  || ALL OF THESE ARE USED TO CLEAR THINGS
CLEAR_INPUT_SINE DB 9 DUP (10,13)											;  ||
				 DB 3 DUP (180 DUP (' ')), '$'								;  ||
CLEAR_TB_AND_VPD DB 7 DUP (' '), '$'										;  ||
CLEAR_FOR_MAIN DB 55 DUP (10,13)											;  ||		
			   DB 15 DUP (180 DUP (' ')), '$'								;  ||
CLEAR_ALL DB 64 DUP (180 DUP (' ')), '$'									;¯¯¯¯¯¯
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
;====================================== END OF DATA ========================;
;===========================================================================;
                                                                            ;
CODESEG                                                                     ;
                                                                            ;
;===========================================================================;
;========================= THIS IS THE CODESEGMENT, DO PUT CODE HERE =======;
;========================================= FUNCTIONS =======================;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
PROC CALCULATE_SCREEN                                                       ;
;=============================                                              ;
;	CALCULATE ONE SCREEN WITH GIVEN VALUES                                  ;
;=============================                                              ;
;|	VALUES ARE TAKEN FROM THE DATASEGMENT                                   ;
;=============================                                              ;
	MOV CX, OFFSET SCREEN_ARRAY												;
	ADD CX, [CURRENT_LOC]                                                   ;
	                                                                        ;
	PUSH CX                                                                 ;
	PUSH [X]                                                                ;
                                                                            ;
	MOV CX, [FREQUENCY]                                                     ;
	PUSH CX                                                                 ;
                                                                            ;
	MOV CX, [WORD PTR TB]                                                   ;
	PUSH CX                                                                 ;
                                                                            ;
	MOV CX, [WORD PTR TB+2]                                                 ;
	PUSH CX                                                                 ;
                                                                            ;
	MOV CX, OFFSET FREE_SPACE                                               ;
	PUSH CX                                                                 ;
                                                                            ;
	MOV CX, OFFSET LOOK_UP_TABLE1                                           ;
	PUSH CX                                                                 ;
                                                                            ;
	MOV CX, [PRE_AMP]                                                       ;
	PUSH CX                                                                 ;
	                                                                        ;
	MOV CX, [AMP]                                                           ;
	PUSH CX                                                                 ;
                                                                            ;
	CALL CALCULATE															;SEE FUNCTION'S DOCUMENTATION
	                                                                        ;
	ADD [CURRENT_LOC], 2                                                    ;
	INC [X]                                                                 ;
	                                                                        ;
	RET                                                                     ;
ENDP CALCULATE_SCREEN                                                       ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
PROC MUL_32_BY_32                                                           ;
;=============================                                              ;
;	MULTIPLY 32BIT BY 32BIT                                                 ;
;=============================                                              ;
;| WILL GET OFFSETS OF TWO NUMBERS                                          ;
;| THEN MULTIPLY THEM                                                       ;
;| RESULT IS STORED IN DX:CX:BX:AX                                          ;
;|                                                                          ;
;|	PART 1 NUM1                                                             ;
;|	PART 2 NUM1                                                             ;
;|	PART 1 NUM2                                                             ;
;|	PART 2 NUM2                                                             ;
;|	OFFSET FREE SPACE                                                       ;
;|                                                                          ;
;|	NOTICE! THIS PROCEDURE WILL ERASE PREVIOUS VALUES IN AX,BX,CX,DX        ;
;|                                                                          ;
;| WRITTEN BY: ALEXANDER ZHAK                                               ;
;| TAKEN FROM HTTP://STACKOVERFLOW.COM/QUESTIONS/29246857/MULTIPLYING-32-BIT;
;| -TWO-NUMBERS-ON-8086-MICROPROCESSOR                                      ;
;=============================                                              ;
                                                                            ;
                                                                            ;
PUSH BP                                                                     ;
MOV BP, SP                                                                  ;
                                                                            ;
	MOV SI, [BP+12]                                                         ;
	MOV DI, [BP+10]                                                         ;
	XOR AX, AX                                                              ;
	XOR BX, BX                                                              ;
	XOR CX, CX                                                              ;
	XOR DX, DX                                                              ;
PUSH BX                                                                     ;
	MOV BX, [BP+4]                                                          ;
	MOV [BYTE PTR BX], 32                                                   ;
POP BX                                                                      ;
                                                                            ;
_LOOP:                                                                      ;
                                                                            ;
	TEST SI, 1                                                              ;
	JZ SHORT _CONT                                                          ;
	ADD CX, [BP+8]                                                          ;
	ADC DX, [BP+6]                                                          ;
                                                                            ;
_CONT:                                                                      ;
                                                                            ;
	RCR DX, 1                                                               ;
	RCR CX, 1                                                               ;
	RCR BX, 1                                                               ;
	RCR AX, 1                                                               ;
	RCR DI, 1                                                               ;
	RCR SI, 1                                                               ;
                                                                            ;
PUSH BX                                                                     ;
	MOV BX, [BP+4]                                                          ;
	DEC [BYTE PTR BX]                                                       ;
POP BX                                                                      ;
                                                                            ;
	JNZ SHORT _LOOP                                                         ;
                                                                            ;
	POP BP                                                                  ;
	RET 10                                                                  ;
ENDP MUL_32_BY_32                                                           ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
PROC PRINTE_AT_LOC_AND_VPD                                                  ;
;=============================                                              ;
;	TAKE A VALUE FROM THE SCREEN'S ARRAY                                    ;
;	PRINT IT TO THE SCREEN AFTER MULTIPLYING IT                             ;
;	BY VOLTS PER DIVISION VALUE                                             ;
;	ALSO MAKE SURE THAT THE VALUE IS WITHIN THE SIZE LIMIT                  ;
;=============================                                              ;
;|GET VALUES FROM STACK:                                                    ;
;|X 							[BP+10]                                     ;
;|SCREEN_SIZE 					[BP+8]                                      ;
;|VPD (WILL BE DIVIDED BY 256) 	[BP+6]                                      ;
;|CURRENT LOCATION 				[BP+4]                                      ;
;=============================                                              ;
	                                                                        ;
	PUSH BP                                                                 ;
	MOV BP, SP                                                              ;
	PUSH AX CX                                                              ;
	                                                                        ;
	PUSH [BP+6]																;
	                                                                        ;
	MOV CX, [BP+4] 															;
	PUSH CX                                                                 ;
	                                                                        ;
	PUSH [BP+8]																;
	                                                                        ;
	CALL PART5_DETERMINE_LOCATION_ON_SCREEN									;
	POP AX																	;FUNCTION RETURNS Y VALUE
		                                                                    ;
	CMP AX, 200																;UPPER BORDER IS 200px
	JL LESS_THAN                                                            ;
	                                                                        ;
	MOV CX, 820																;LOWER BORDER IS 820px
	CMP AX, CX                                                              ;
	JNG OK                                                                  ;
	                                                                        ;
	MOV AX, CX                                                              ;
	JMP OK                                                                  ;
	                                                                        ;
LESS_THAN:                                                                  ;
	MOV AX, 200                                                             ;
                                                                            ;
OK:                                                                         ;
	PUSH AX                                                                 ;
	PUSH [BP+10]															;
	CALL DRAW_FUNCTION														;DRAW Y VALUE FOR GIVEN X
	                                                                        ;
	POP CX AX                                                               ;
	POP BP                                                                  ;
	RET 8                                                                   ;
ENDP PRINTE_AT_LOC_AND_VPD                                                  ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
PROC PART1_MUL_X_F_TB_DIV_0XFFFFFH                                          ;
;=============================                                              ;
;	PART ONE OF CALCULATING THE SINE                                        ;
;=============================                                              ;
;| THIS PROGRAM WILL GET THE FOLLOWING                                      ;
;| THINGS VIA THE STACK:                                                    ;
;|		X VALUE (1-360) 		BP+12                                       ;
;|		FREQUENCY (1-20,000) 	BP+10                                       ;
;|		OFFSET FREE SPACE 		BP+8                                        ;
;|		PART 1 OF TIME BASE 	BP+6                                        ;
;|		PART 2 OF TIME BASE 	BP+4                                        ;
;| IT WILL THEN RETURN THE THE DIVIDEND                                     ;
;| OF (X*FREQUENCY*360*TB) DIVIDED BY                                       ;
;| 0XFFFFFH (HENCE THE NAME)                                                ;
;|                                                                          ;
;| POP AX                                                                   ;
;| POP DX                                                                   ;
;| WILL PUT THE DIVIDEND CORRECTLY IN DX:AX                                 ;
;=============================                                              ;
                                                                            ;
	PUSH BP                                                                 ;
	MOV BP, SP                                                              ;
                                                                            ;
	PUSH AX                                                                 ;
	PUSH BX                                                                 ;
	PUSH CX                                                                 ;
	PUSH DX                                                                 ;
                                                                            ;
	MOV AX, 360                                                             ;
	MUL [WORD PTR BP+12]								                    ;
	PUSH AX                                                                 ;
	PUSH DX                                                                 ;
                                                                            ;
	PUSH [BP+10]															;THE FREQUENCY
                                                                            ;
	MOV CX, 0										                        ;
	PUSH CX	    										                    ;
	PUSH [BP+8]																;FREE SPACE
                                                                            ;
	CALL MUL_32_BY_32														;WILL MULTIPLY 360*X BY FREQUENCY
																			;AND RETURN THE NUMBER IN DX:CX:BX:AX
	PUSH AX                                                                 ;
	PUSH BX																	;WE ONLY NEED THE LOWER 32-BITS (RESULT FITS THERE)
                                                                            ;
	PUSH [BP+6]                                                             ;
	PUSH [BP+4]																;BP+6, BP+4 ARE BOTH PARTS OF THE TIME BASE
	PUSH [BP+8]                                                             ;
                                                                            ;
	CALL MUL_32_BY_32														;MULTIPLY BY TIME BASE. DIVIDING BY 0XFFFFFH IS THE SAME AS TAKING
																			;EVERYTHING EXCEPT FIRST 20 BITS
	SQUISH_TO_DOUBLE_WORD													;WHEN WE TAKE EVERYTHING EXCEPT FIRST 20 BITS, WE WILL GET A NUMBER
																			;WHICH IS, AT ITS BIGGEST, A DOUBLE WORD (OXFFFF FFFF). 
																			;THIS MACRO WILL LEAVE THE NUMBER IN CX:BX
	MOV [BP+12], CX                                                         ;
	MOV [BP+10], BX															;MOVE THE NUMBER TO THE STACK
                                                                            ;
	POP DX                                                                  ;
	POP CX                                                                  ;
	POP BX                                                                  ;
	POP AX                                                                  ;
	POP BP                                                                  ;
                                                                            ;
	RET 6                                                                   ;
ENDP PART1_MUL_X_F_TB_DIV_0XFFFFFH                                          ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
PROC PART2_MOD_180_CHECK_IF_DIVIDEND_IS_EVEN_OR_ODD                         ;
;=============================                                              ;
;	PART TWO OF CALCULATING THE SINE                                        ;
;=============================                                              ;
;| THIS PROGRAM WILL GET THE FOLLOWING                                      ;
;| THINGS VIA THE STACK:                                                    ;
;|		AX 					 BP+6                                           ;
;|		DX					 BP+4                                           ;
;| IT WILL THEN RETURN DX:AX MOD 180                                        ;
;| AND IF THE DIVIDEND OF DX:AX IS                                          ;
;| EVEN OR ODD                                                              ;
;|(THIS IS IMPORTANT BECUASE SIN(1) = SIN(179), BUT SIN(181) = -SIN (1))    ;
;|                                                                          ;
;| POP DX                                                                   ;
;| POP AX                                                                   ;
;| WILL PUT 0 IN AX IF DIVIDEND IS EVEN, ELSE: 1                            ;
;| AND THE MODULU OF 180 IN DX                                              ;
;=============================                                              ;
	PUSH BP                                                                 ;
	MOV BP, SP                                                              ;
	PUSH AX                                                                 ;
	PUSH BX                                                                 ;
	PUSH CX                                                                 ;
	PUSH DX                                                                 ;
                                                                            ;
	MOV AX, [BP+4]                                                          ;
	MOV DX, [BP+6]                                                          ;
                                                                            ;
	MOV CX, 180                                                             ;
	DIV CX                                                                  ;
                                                                            ;
	MOV BX, AX                                                              ;
	AND AX, 1                                                               ;
	MOV [BP+6], AX                                                          ;
	MOV [BP+4], DX                                                          ;
                                                                            ;
	POP DX                                                                  ;
	POP CX                                                                  ;
	POP BX                                                                  ;
	POP AX                                                                  ;
	POP BP                                                                  ;
	RET                                                                     ;
ENDP PART2_MOD_180_CHECK_IF_DIVIDEND_IS_EVEN_OR_ODD                         ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
PROC PART4_TAKE_VALUE_FROM_ARRAY_DIV_BY_VPD                                 ;
;=============================                                              ;
;	                                                                        ;
;=============================                                              ;
;| THIS PROGRAM WILL TAKE THE CURRENT VALUE AT A LOCATION IN THE SCREEN ARRA;
;| THEN MULTIPLY IT BY THE VPD VALUE, AND DIVIDE BY 256                     ;
;|                                                                          ;
;| GETS:                                                                    ;
;|	POSITION IN ARRAY 	BP+6                                                ;
;|	VPD 				BP+4                                                ;
;|                                                                          ;
;|POP AX                                                                    ;
;|WILL RETURN THE VALUE IN AX                                               ;
;=============================                                              ;
	                                                                        ;
	                                                                        ;
	PUSH BP                                                                 ;
	MOV BP, SP                                                              ;
	                                                                        ;
	PUSH BX AX CX                                                           ;
	                                                                        ;
	MOV BX, [BP+6]                                                          ;
	MOV AX, [BX]                                                            ;
	                                                                        ;
	MOV CX, [BP+4]                                                          ;
	IMUL CX                                                                 ;
	                                                                        ;
	MOV CX, 256                                                             ;
	IDIV CX                                                                 ;
	                                                                        ;
	                                                                        ;
	MOV [BP+6], AX                                                          ;
	                                                                        ;
	POP CX AX BX BP                                                         ;
	RET 2                                                                   ;
ENDP PART4_TAKE_VALUE_FROM_ARRAY_DIV_BY_VPD                                 ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
PROC PART5_DETERMINE_LOCATION_ON_SCREEN                                     ;
;=============================                                              ;
;	GIVES FINAL Y VALUE TO PRINT                                            ;
;=============================                                              ;
;|THIS FUNCTION WILL TAKE THE FINAL VALUE                                   ;
;|OF THE SINE AT A CERTAIN LOCATION (AFTER MULTIPLYING BY VPD)              ;
;|IT WILL THEN CALCUATE WHERE IT SHOULD BE PRINTED RELATIVE TO              ;
;|LOCATION (0,0) WHICH IS THE TOP LEFT CORNER OF THE SCREEN                 ;
;|                                                                          ;
;|GETS:                                                                     ;
;|	VPD 					BP+8                                            ;
;|	LOCATION IN ARRAY 		BP+6                                            ;
;|	SCREEN SIZE 			BP+4                                            ;
;|                                                                          ;
;|POP AX                                                                    ;
;|WILL CORRECTLY PUT THE VALUE IN AX                                        ;
;=============================                                              ;
	                                                                        ;
	PUSH BP                                                                 ;
	MOV BP, SP                                                              ;
	                                                                        ;
	PUSH CX AX                                                              ;
	                                                                        ;
	PUSH [BP+6]                                                             ;
	                                                                        ;
	MOV CX, [BP+8]                                                          ;
	PUSH CX                                                                 ;
	                                                                        ;
	CALL PART4_TAKE_VALUE_FROM_ARRAY_DIV_BY_VPD								;
	POP AX																	;THE FUNCTION RETURNS THE VALUE OF THE SINE
																			;AFTER MULTIPLYING BY VPD AND DIVIDING BY 256
	MOV CX, [BP+4]                                                          ;
	SUB CX, AX																;LOCATION IS SCREEN SIZE - CALCULATED VALUE
	                                                                        ;
	MOV [BP+8], CX                                                          ;
	                                                                        ;
	POP AX CX BP                                                            ;
	                                                                        ;
	RET 4                                                                   ;
ENDP PART5_DETERMINE_LOCATION_ON_SCREEN                                     ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
PROC CALCULATE                                                              ;
;=============================                                              ;
;	THE FUNCTION THAT CALCULATES THE SINE VALUE AT A SPECIFIC               ;
;	X VALUE. THIS IS ONLY THE RAW VALUE, BEFORE PRINTING IT MUST BE         ;
;	MULTIPLIED BY THE VPD, THEN DIVIDED BY 256, AND THEN THE VALUE MUST BE  ;
;	SUBTRACTED FROM THE SIZE OF HALF OF THE SCREEN                          ;
;	(WHICH IS CALLED IN CODE SCREEN_SIZE - NOT HALF_SCREEN_SIZE)            ;
;=============================                                              ;
;|                                                                          ;
;|GETS                                                                      ;
;|	ARRAY LOCATION				BP+20                                       ;
;|	X VALUE						BP+18                                       ;
;|	FREQUENCY					BP+16                                       ;
;|	TB							BP+14                                       ;
;|	TB+2						BP+12                                       ;
;|	OFFSET FREE SPACE			BP+10                                       ;
;|	OFFSET LOOK UP TABLE		BP+8                                        ;
;|	PRE_AMP						BP+6                                        ;
;|	AMP 						BP+4                                        ;
;|                                                                          ;
;|NO NEED TO POP ANYTHING, THE VALUE IS IMMEDIATELY ADDED TO THE ARRAY      ;
;|THAT HOLD THE VALUES OF THE SINES (SCREEN_ARRAY)                          ;
;=============================                                              ;
                                                                            ;
	PUSH BP                                                                 ;
	MOV BP, SP                                                              ;
	PUSH AX BX CX DX DI                                                     ;
                                                                            ;
	PUSH [BP+18]															;X
	PUSH [BP+16]															;FREQ
	PUSH [BP+10]															;FREE SPACE
	PUSH [BP+14]															;TB - PART 1 [WORD PTR TB]
	PUSH [BP+12]															;TB - PART 2 [WORD PTR TB+2]
                                                                            ;
	CALL PART1_MUL_X_F_TB_DIV_0XFFFFFH                                      ;
	CALL PART2_MOD_180_CHECK_IF_DIVIDEND_IS_EVEN_OR_ODD                     ;
                                                                            ;
	POP DX                                                                  ;
	POP DI																	;GET THE ANGLE OF THE SINE AT LOCATION X
																			;MODULU 180 IN DX, AND WHETHER THE SINE SHOULD
																			;BE ADDED OR SUBTRACTED (IS IT NEGATIVE OR POSITIVE)
	MOV BX, [BP+8]															;
	ADD BX, DX                                                              ;
	ADD BX, DX                                                              ;
	MOV AX, [BX]															;PUT THE VALUE CORRESPONDING TO THE ANGLE IN AX
	                                                                        ;
	MOV CX, [BP+6]															;DIVIDEND OF AMPLITUDE
	CMP CL, 0																;
	JNLE PLUS																;CHECK IF IT IS NEGATIVE OR POSITIVE																	
MINUS:																		;IF NEGATIVE
	NEG CL																	;	|
	XOR CH, CH																;	V
	NEG CX																	;LIKE DOING MOV CX, CL (IF THIS INSTRUCTION WAS LEGAL)
PLUS:	                                                                    ;
	IMUL CX																	;MULTIPLY BY DIVIDEND
	                                                                        ;
	MOV CX, [BP+4]															;DIVISOR OF AMPLITUDE
	CMP CL, 0	                                                            ;
	JNLE PLUS2																;NOW CHECK IF THIS IS NEGATIVE
MINUS2:                                                                     ;
	NEG CL                                                                  ;
	XOR CH, CH                                                              ;
	NEG CX																	;SAME AS BEFORE
PLUS2:	                                                                    ;
	IDIV CX																	;DIVIDE BY DIVISOR 
	                                                                        ;
	CMP DI, 0																;THIS CHECKS IF THE ANGLE IS NEGATIVE
	JNE ACTUALLY_MINUS														;IF IT IS CHANGE THE VALUE'S SIGN
	JMP DONE                                                                ;
	                                                                        ;
ACTUALLY_MINUS:                                                             ;
	NEG AX                                                                  ;
	                                                                        ;
DONE:                                                                       ;
	MOV BX, [BP+20]                                                         ;
	ADD [BX], AX															;FINALLY, ADD THE VALUE TO THE SCREEN ARRAY AT THE SPECIFIC LOCATION
																			;NOT THAT IF THE VALUE IS NEGATIVE, THIS IS THE SAME AS SUBTRACTING THE VALUE
	POP DI DX CX BX AX BP                                                   ;
	                                                                        ;
	RET 18                                                                  ;
ENDP CALCULATE                                                              ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
PROC INC_DD                                                                 ;
;=============================                                              ;
;	USED TO INCREMENT A DOUBLE WORD                                         ;
;=============================                                              ;
;|THIS PROGRAM WILL INCREMENT A DOUBLE-WORD                                 ;
;|VARIABLE.                                                                 ;
;|                                                                          ;
;|THIS PROGRAM GETS:                                                        ;
;|	OFFSET OF FIRST WORD IN DOUBLE WORD 	BP+6                            ;
;|	OFFSET OF SECOND WORD IN DOUBLE WORD  	BP+4                            ;
;|                                                                          ;
;|NO NEED TO POP ANYTHING                                                   ;
;|ANSWER STAYS AT THE LOCATION, WHOSE OFFSET IS GIVEN                       ;
;|BEFORE CALLING THIS FUNCTION                                              ;
;=============================                                              ;
                                                                            ;
PUSH BP                                                                     ;
MOV BP, SP                                                                  ;
PUSH BX                                                                     ;
                                                                            ;
MOV BX, [BP+6]																;
CMP [WORD PTR BX], 0FFFFH													;IS THE LOWER PART "FULL"?
JE OVER																		;IF SO, SET IT TO 0 AND INCREMENT HIGH PART
                                                                            ;
MOV BX, [BP+6]																;
INC [WORD PTR BX]															;ELSE, INC LOWER PART
JMP DONEI                                                                   ;
                                                                            ;
OVER:                                                                       ;
MOV BX, [BP+4]															    ;
INC [WORD PTR BX]                                                           ;
                                                                            ;
MOV BX, [BP+6]                                                              ;
MOV [WORD PTR BX], 0                                                        ;
                                                                            ;
                                                                            ;
DONEI:                                                                      ;
POP BX                                                                      ;
POP BP                                                                      ;
RET 4                                                                       ;
                                                                            ;
ENDP INC_DD                                                                 ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
PROC OPEN_FILE                                                              ;
;=============================                                              ;
;	OPENS A FILE                                                            ;
;=============================                                              ;
;|THIS PROGRAM WILL OPEN A FILE, AND PLACE THE HANDLE OF IT AT A CERTAIN    ;
;|LOCATION                                                                  ;
;|                                                                          ;
;|THE FUNCTION GETS:                                                        ;
;|	OFFSET FILNAME 		BP+6                                                ;
;|	OFFSET HANDLE 		BP+4                                                ;
;|                                                                          ;
;|NO NEED TO POP ANYTHING                                                   ;
;|THE HANDLE OF THE FILE WILL BE KEPT AT THE GIVEN LOCATION                 ;
;=============================                                              ;
                                                                            ;
                                                                            ;
PUSH BP                                                                     ;
MOV BP, SP                                                                  ;
PUSH AX BX DX                                                               ;
                                                                            ;
MOV AH, 3DH                                                                 ;
MOV AL, 0                  													;OPEN ATTRIBUTE: 0 - READ-ONLY
MOV DX, [BP+6]     															;FILE NAME
INT 21H                    													;(INT 21H/AH = 3DH) OPENS THE FILE,WITH THE NAME AT [DX]. WE ASSUME THAT THE FILE EXISTS.
																			;HANDLE IS KEPT IN AX
MOV BX, [BP+4]                                                              ;
MOV [BX], AX                                                                ;
                                                                            ;
POP DX BX AX                                                                ;
POP BP                                                                      ;
RET 4                                                                       ;
ENDP OPEN_FILE                                                              ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
PROC CLOSE_FILE                                                             ;
;=============================                                              ;
;	CLOSE THE FILE, AND RESET THE IN-FILE LOCATION COUNTER                  ;
;=============================                                              ;
;|THIS FUNCTION CLOSES THE CURRENT OPENED FILE,                             ;
;|FREEING UP THE HANDLE FOR FUTURE USE.                                     ;
;|IT ALSO RESETS CURRENTlOC, WHICH IS THE COUNTER FOR THE CURRENT           ;
;|IN-FILE LOCATION.                                                         ;
;|                                                                          ;
;|THE FUNCTION GETS THE VALUES FROM THE DATA SEGMENT, AND RETURNS NOTHING   ;
;=============================                                              ;
PUSH AX BX                                                                  ;
MOV AH, 3EH                                                                 ;
MOV BX, [HANDLE] ; FILE HANDLE                                              ;
INT 21H																		;(INT 21H/AH = 3EH) CLOSES THE FILE, WHOSE HANDLE IS IN BX
                                                                            ;
MOV [WORD PTR CURRENTLOC], 0                                                ;
MOV [WORD PTR CURRENTLOC+2], 0                                              ;
                                                                            ;
POP BX AX                                                                   ;
RET                                                                         ;
ENDP CLOSE_FILE                                                             ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
PROC CHANGE_LOC_IN_FILE                                                     ;
;=============================                                              ;
;	CHANGE THE LOCATION IN THE CURRENTLY OPENED FILE                        ;
;=============================                                              ;
;|THE FUNCTION TAKES THE LOCATION FROM [CURRENTLOC] IN THE DATASEG          ;
;|IT DOESN'T RETURN ANYTHING                                                ;
;=============================                                              ;
PUSH AX BX CX DX                                                            ;
                                                                            ;
MOV AH, 42H                                                                 ;
MOV AL, 0                                                                   ;
MOV BX, [HANDLE]                                                            ;
MOV CX, [WORD PTR CURRENTLOC+2]                                             ;
MOV DX, [WORD PTR CURRENTLOC]                                               ;
INT 21H																		;(INT 21H/AH = 42H) CHANGES POINTER IN OPENED FILE
                                                                            ;
POP DX CX BX AX                                                             ;
	RET                                                                     ;
ENDP CHANGE_LOC_IN_FILE                                                     ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
PROC READ_FROM_FILE                                                         ;
;=============================                                              ;
;	READ ONE BYTE FROM FILE                                                 ;
;=============================                                              ;
;|THIS FUNCTION READS THE DATA WHICH IS AT OFFSET [CURRENTLOC]              ;
;|IN A GIVEN FILE                                                           ;
;|                                                                          ;
;|THE FUNCTION GETS:                                                        ;
;|	OFFSET HANDLE 			BP+6                                            ;
;|	OFFSET READ_DATA 		BP+4                                            ;
;|                                                                          ;
;|THE READ BYTE IS STORED AT THE OFFSET GIVEN                               ;
;=============================                                              ;
PUSH BP                                                                     ;
MOV BP, SP                                                                  ;
                                                                            ;
PUSH AX BX CX DX                                                            ;
                                                                            ;
CALL CHANGE_LOC_IN_FILE                                                     ;
                                                                            ;
MOV AH, 3FH                                                                 ;
MOV BX, [BP+6]                                                              ;
MOV BX, [BX]          														;FILE HANDLE
MOV CX, 1               													;NUMBER OF BYTES TO READ
MOV DX, [BP+4]          													;WHERE TO PUT READ DATA
INT 21H																		;(INT 21H/AH = 3FH) READS DATA FROM FILE
                                                                            ;
POP DX CX BX AX                                                             ;
POP BP                                                                      ;
RET 4                                                                       ;
ENDP READ_FROM_FILE                                                         ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
PROC DRAW_FUNCTION                                                          ;
;=============================                                              ;
;	GETS BOTH X AND Y VALUES, DRAWS THE FUNCTION                            ;
;=============================                                              ;
;| THIS FUNCTION WILL GET TWO VALUES                                        ;
;| THE FIRST WILL BE Y VALUE                                                ;
;| SECOND WILL BE X VALUE, WHICH IS                                         ;
;| CALCUATED USING THE FUNCTION "CALCULATE_Y"                               ;
;| IT WILL THEN DRAW THE FUNCTION IN THE GRAPHICS SCREEN                    ;
;=============================                                              ;
	PUSH BP                                                                 ;
	MOV BP, SP                                                              ;
    PUSH AX                                                                 ;
	PUSH DX                                                                 ;
	PUSH CX                                                                 ;
	                                                                        ;
	MOV DX, [BP+6]	                                                        ;
    MOV CX, [BP+4]                                                          ;
                                                                            ;
	MOV AL, 15                                                              ;
    MOV AH, 0CH                                                             ;
	MOV BH, 0                                                               ;
	INT 10H																	;PRINT
                                                                            ;
	POP CX                                                                  ;
	POP DX                                                                  ;
	POP AX                                                                  ;
	POP BP                                                                  ;
                                                                            ;
	RET 4                                                                   ;
ENDP DRAW_FUNCTION                                                          ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
PROC PRINT_STRING                                                           ;
;=============================                                              ;
;	PRINTS A STRING, WHICH ENDS WITH A '$'                                  ;
;=============================                                              ;
;|THE FUNCTION GETS THE OFFSET VIA THE STACK                                ;
;=============================                                              ;
	PUSH AX BX DX                                                           ;
                                                                            ;
	MOV AH, 02H                                                             ;
	MOV BH, 0                                                               ;
	MOV DH, 0                                                               ;
	MOV DL, 0                                                               ;
	                                                                        ;
	INT 10H																	;SETS THE CURSOR POSITION AT THE VERY TOP OF THE SCREEN
	POP DX BX AX															;IF WE DON'T DO THIS, IT WILL PRINT THE MENU FROM THE LAST
																			;PLACE THAT IT STOPPED PRINTING AT (FOR EXAMPLE: AT THE VERY BOTTOM OF THE SCREEN)
	PUSH BP                                                                 ;
	MOV BP, SP                                                              ;
	PUSH AX                                                                 ;
	PUSH DX                                                                 ;
	                                                                        ;
	                                                                        ;
	MOV AH, 9                                                               ;
	MOV DX, [BP+4]                                                          ;
	INT 21H            														;PRINT UNTILL YOU ENCOUNTER A '$'
                                                                            ;
OVER_LIMIT:	                                                                ;
	POP AX                                                                  ;
	POP DX                                                                  ;
	POP BP                                                                  ;
	RET 2                                                                   ;
ENDP PRINT_STRING                                                           ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
PROC DELAY                                                                  ;
;=============================                                              ;
;	CAUSES A DELAY OF N/18 SECOND                                           ;
;=============================                                              ;
;| SI - TIMER SINGNALS COUNTER                                              ;
;| DL - PART OF CLOCK                                                       ;
;| BL - LAST VALUE OF DL                                                    ;
;| CX - HOLDS THE NUMBER OF TIMES TO LOOP                                   ;
;|(READING THE CLOCK REQUIRES REGISTER CX, THAT IS WHY WE PUSH IT AND POP IT;
;| MANY TIMES)                                                              ;
;|                                                                          ;
;|FUNCTION GETS NUMBER OF SECONDS                                           ;
;|TO DELAY IN STACK                                                         ;
;=============================	                                            ;
                                                                            ;
	PUSH BP                                                                 ;
	MOV BP,SP                                                               ;
	PUSH SI                                                                 ;
	PUSH AX                                                                 ;
	PUSH BX                                                                 ;
	PUSH DX                                                                 ;
		                                                                    ;
		                                                                    ;
	MOV CX, [BP+4]                                                          ;
	PUSH CX                                                                 ;
                                                                            ;
	MOV AH, 2CH                                                             ;
	INT 21H 																;READ CLOCK
	MOV BL, DL                                                              ;
	                                                                        ;
	POP CX	                                                                ;
LOOP_IF_MORE_THAN_ONE_SECOND:                                               ;
	MOV SI, 1                                                               ;
	MAINLOOP:                                                               ;
	PUSH CX                                                                 ;
	INT 21H      															;READ CLOCK
	CMP BL, DL                                                              ;
	POP CX                                                                  ;
	JE MAINLOOP        														;CONTINUE IF CLOCK HASN'T CHANGED SINCE THE LAST TIME 
		                                                                    ;
	MOV BL, DL   															;DL IS UPDATED AND BL HOLD LAST CLOCK VALUE
	DEC SI																	;DEC SI, WHICH HOLD THE NUMBER OF TIME TO RUN THIS 
																			;CHECK (18 TIMES IS ~ 1 SECOND)
	JNZ MAINLOOP                                                            ;
	DEC CX                                                                  ;
	JNZ LOOP_IF_MORE_THAN_ONE_SECOND                                        ;
		                                                                    ;
	                                                                        ;
	POP DX                                                                  ;
	POP BX                                                                  ;
	POP AX                                                                  ;
	POP SI                                                                  ;
	POP BP                                                                  ;
		                                                                    ;
	RET 2                                                                   ;
ENDP DELAY                                                                  ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
PROC WRITE_AT_LOCATION                                                      ;
;=============================                                              ;
;	WRITES A STRING AT A LOCATION                                           ;
;=============================                                              ;
;|THIS PROGRAM WILL PRINT A STRING ENDING IN A GIVEN CHARACTER              ;
;|AT A GIVEN LOCATION                                                       ;
;|                                                                          ;
;|GETS:                                                                     ;
;|	X 					BP+12                                               ;
;|	Y 					BP+10                                               ;
;|	SCREEN TO PRINT IN	BP+8                                                ;
;|	OFFSET OF START 	BP+6                                                ;
;|	KEY TO END ON 		BP+4	                                            ;
;=============================                                              ;
                                                                            ;
	                                                                        ;
	PUSH BP                                                                 ;
	MOV BP, SP                                                              ;
	PUSH AX                                                                 ;
	PUSH BX                                                                 ;
	PUSH CX                                                                 ;
	PUSH DX                                                                 ;
	PUSH DI                                                                 ;
	                                                                        ;
	MOV BH, 0                                                               ;
	MOV DH, [BP+10]                                                         ;
	MOV DL, [BP+12]                                                         ;
	                                                                        ;
	MOV DI, [BP+6]                                                          ;
                                                                            ;
LOOP_FOR_STRING:                                                            ;
	MOV AH, 02H                                                             ;
	INT 10H                                                                 ;
	                                                                        ;
	PUSH DX                                                                 ;
	PUSH BX                                                                 ;
	MOV DL, [DI]                                                            ;
	CMP DL, [BP+4]                                                          ;
	JE NO_MORE                                                              ;
	                                                                        ;
	MOV AH, 09H                                                             ;
	MOV AL, DL                                                              ;
	MOV CX, 1                                                               ;
	MOV BH, [BP+8]                                                          ;
	MOV BL, 015                                                             ;
	INT 10H	                                                                ;
	POP BX                                                                  ;
	POP DX                                                                  ;
	INC DL                                                                  ;
	INC DI                                                                  ;
	JMP LOOP_FOR_STRING                                                     ;
	                                                                        ;
NO_MORE:	                                                                ;
	POP BX                                                                  ;
	POP DX                                                                  ;
	                                                                        ;
	POP DI                                                                  ;
	POP DX                                                                  ;
	POP CX                                                                  ;
	POP BX                                                                  ;
	POP AX                                                                  ;
	POP BP                                                                  ;
	CLEAR_THING																;CLEAR THE BUFFER, JUST IN CASE WE USED IT
	RET 10                                                                  ;
ENDP WRITE_AT_LOCATION	                                                    ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
PROC PRINT_INFO                                                             ;
;=============================                                              ;
;	                                                                        ;
;=============================                                              ;
;|THIS PROGRAM WILL RECIEVE A NUMBER				                        ;
;|AND THE MAXIMUM LENGTH OF THE STRING THAT THE NUMBER CAN BECOME, THEN     ;
;|MAKE THE NUMBER INTO A STRING AND CALCULATE HOW MANY SPACES               ;
;|SHOULD BE PRINTED BEFORE THE NUMBER, SO THAT IT IS PERFECTLY              ;
;|CENTERED ACCORDING TO A CERTAIN STARTING POSITION                         ;
;|                                                                          ;
;|GETS:                                                                     ;
;|FIRST PART OF NUMBER 							BP+12                       ;
;|SECOND PART OF NUMBER							BP+10                       ;
;|WHAT TO DIV BY (2 FOR BINARY, 10 FOR DEC ...)	BP+8                        ;
;|OFFSET OF ENDING	 							BP+6                        ;
;|LENGTH 										BP+4                        ;
;|																			;
;|POP BX																	;
;|WILL CORRECTLY PLACE THE OFFSET FROM WHICH WE NEED TO START PRINTING IN BX;
;=============================                                              ;
	PUSH BP                                                                 ;
	MOV BP, SP                                                              ;
	PUSH AX DX CX BX DI                                                     ;
	                                                                        ;
	MOV AX, [BP+12]                                                         ;
	MOV DX, [BP+10]                                                         ;
	                                                                        ;
	MOV CX, [BP+8]                                                          ;
	MOV BX, 1                                                               ;BX WILL HOLD THE SIZE OF THE NUMBER+1
                                                                            ;
MORE11:	                                                                    ;
	DIV CX                                                                  ;DIVIDE BY 10, FOR EXAMPLE, TO GET DECIMAL VALUE (THE REMAINDER)
	ADD DL, 30H                                                             ;GET ASCII CHARACTER FOR THE DIGIT
	NEG BX                                                                  ;
	MOV DI, [BP+6]                                                          ;
	MOV [BYTE PTR DI+BX], DL                                                ;THIS IS WHY WE DID NEG BX, WE GET [BYTE PTR DI-BX].
	NEG BX                                                                  ;THIS WAY WE INPUT THE NUMBER BACKWARDS, FROM THE END, TO THE START
	INC BX                                                                  ;
	XOR DX, DX                                                              ;
	CMP AX, 0                                                               ;BY DOING THIS WE RUN THROUHG THE ENTIRE NUMBER,
	JNE MORE11                                                              ;DIVIDING IT BY 10, TAKING THE DIGIT, THE DOING THIS 
                                                                            ;AGAIN UNTILL THE NUMBER IS 0 (UNTILL THERE ARE NO MORE DIGITS)
DONE11:                                                                     ;
	DEC BL                                                                  ;NOW BL IS THE LENGTH OF THE NUMBER
	MOV CL, [BP+4]                                                          ;LENGTH OF THE BUFFER, TO WHICH WE ENTERED THE ASCII CHARACTERS 
	MOV CH, [BP+6]                                                          ;
	SUB CL, BL                                                              ;GET THE NUMBER OF POSITIONS WHICH ARE EMPTY
	SHR CL, 1                                                               ;DIVIDE THAT NUMBER BY 2 TO GET THE NUMBER OF SPACES THAT WE NEED TO PRING
	ADD BL, CL                                                              ;
	SUB CH, BL                                                              ;SUBTRACT THE LENGTH OF THE NUMBER(INCLUDING SPACES) FROM THE OFFSET OF OUR BUFFER
	MOV BL, CH                                                              ;
	                                                                        ;
	MOV [BP+12], BX                                                         ;AND RETURN THAT NUMBER
	                                                                        ;
	POP DI BX CX DX AX                                                      ;
	POP BP                                                                  ;
	RET 8                                                                   ;
ENDP PRINT_INFO	                                                            ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
PROC PUTIN_SINE_ARRAY                                                       ;
;=============================                                              ;
;	PUTS SINE'S INFROMATION IN SINE ARRAY                                   ;
;=============================                                              ;
;|THE PROGRAM WILL PLACE A GIVEN SINE'S                                     ;
;|INFORMATION IN THE SINE ARRAY IN THE ORDER:                               ;
;|FREQUENCY                                                                 ;
;|DIVIDEND OF AMPLITUDE                                                     ;
;|DIVISOR OF AMPLITUDE                                                      ;
;|                                                                          ;
;|GETS:                                                                     ;
;|	CURRENT SINE 			BP+12                                           ;
;|	OFFSET SINES_ARRAY 		BP+10                                           ;
;|	FREQU 					BP+8                                            ;
;|	DIVIDEND OF AMP 		BP+6                                            ;
;|	DIVISOR OF AMP 			BP+4                                            ;
;=============================                                              ;
	PUSH BP                                                                 ;
	MOV BP, SP                                                              ;
	PUSH AX BX CX DX DI                                                     ;
	                                                                        ;
	MOV AX, [BP+12]                                                         ;
	MOV CL, 6                                                               ;
	MUL CL																	;EACH SINE NEEDS 3 WORDS OF DATA, WHICH ARE 6 BYTES
	MOV BX, AX                                                              ;
	MOV CX, [BP+8]                                                          ;
	ADD BX, [BP+10]                                                         ;
	MOV [BX], CX                                                            ;
	ADD BX, 2                                                               ;
	MOV CX, [BP+6]                                                          ;
	MOV [BX], CX                                                            ;
	ADD BX, 2                                                               ;
	MOV CX, [BP+4]                                                          ;
	MOV [BX], CX                                                            ;
	                                                                        ;
	POP DI DX CX BX AX                                                      ;
	POP BP                                                                  ;
	RET 10                                                                  ;
ENDP PUTIN_SINE_ARRAY                                                       ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
PROC TAKE_FROM_SINE_ARRAY                                                   ;
;=============================                                              ;
;	TAKE INFROMATION OF SINE FROM SINE ARRAY                                ;
;=============================                                              ;
;|THIS PROGRAM WILL TAKE THE INFROMATION OF A GIVEN SINE                    ;
;|FROM THE SINE ARRAY                                                       ;
;|                                                                          ;
;|GETS:                                                                     ;
;|	SINE NUMBER TO TAKE 	BP+6                                            ;
;|	OFFSET SINES_ARRAY 		BP+4                                            ;
;|                                                                          ;
;|	POP AX                                                                  ;
;|	POP DX                                                                  ;
;|	POP DI                                                                  ;
;|WILL CORRECTLY PUT THE FREQUENCY IN AX,                                   ;
;|THE DIVIDEND OF THE AMPLITUDE IN DX,                                      ;
;|AND THE DIVISOR OF THE AMPLITUDE IN DI                                    ;
;=============================                                              ;
	                                                                        ;
	PUSH BP                                                                 ;
	MOV BP, SP                                                              ;
	PUSH AX CX BX DX DI                                                     ;
	                                                                        ;
	MOV AX, [BP+6]                                                          ;
	MOV CL, 6                                                               ;
	MUL CL																	;EACH SINE HAS 3 WORDS OF DATA, WHICH ARE 6 BYTES
	MOV BX, AX                                                              ;
	ADD BX, [BP+4]                                                          ;
	MOV AX, [BX]                                                            ;
	MOV [BP+4], AX                                                          ;
	ADD BX, 2																;TO MOVE FROM ONE WORD TO THE OTHER WE NEED TO ADD 2
	MOV DX, [BX]                                                            ;
	MOV [BP+6], DX                                                          ;
	                                                                        ;
	ADD BX, 2                                                               ;
	MOV DI, [BX]                                                            ;
	MOV [BP+8], DI                                                          ;
	                                                                        ;
	POP DI DX BX CX AX                                                      ;
	POP BP                                                                  ;
	RET                                                                     ;
ENDP TAKE_FROM_SINE_ARRAY                                                   ;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
;===================================== END OF FUNCTIONS ====================;
;===========================================================================;
                                                                            ;
                                                                            ;
                                                                            ;
                                                                            ;
                                                                            ;
;===========================================================================;
;=========================================== MAIN ==========================;
                                                                            ;
START:                                                                      ;
;==========================                                                 ;
	MOV AX, @DATA                                                           ;
	MOV DS, AX                                                              ;
                                                                            ;
	MOV AX, 03H                                                             ;
	INT 10H                                                                 ;
                                                                            ;
	MOV AX, 4F02H                                                           ;
	MOV BX, 107H															;SCREEN WITH RES OF 1280*1024
	INT 10H                                                                 ;
;==========================                                                 ;
	                                                                        ;
	DRAW_WELCOME                                                            ;
	JMP _CONTINUE															;IF WE GOT HERE, THIS MEANS THAT WE GOT A KEY WHILE IN THE WELCOME SCREEN
_WAIT:																		;SO WE CAN SKIP WAITING FOR A KEY AND JUST CHECK WHICH KEY WAS PRESSED INSTED
	MOV AH, 0H                                                              ;
	INT 16H																	;USED HERE TO CLEAR THE KEYBOARD BUFFER
	                                                                        ;
	IN AL, 64H																;CHECK KEYBOARD BUFFER STATUS	
	CMP AL, 10B																;10B - BUFFER IS EMPTY
	JE _WAIT                                                                ;
_CONTINUE:	                                                                ;
	IN AL, 60H					                                            ;
	CMP AL, 1																;ESC - EXIT
	JNE _TUT                                                                ;
_EXIT:	                                                                    ;
	JMP EXIT                                                                ;
_TUT:                                                                       ;
	CMP AL, 1CH 															;ENTER - TUTORIAL
	JE _TUT_                                                                ;
	JMP _MAIN                                                               ;
_TUT_:                                                                      ;
	DRAW_MAIN                                                               ;
	WRITE_VPD_AND_TB                                                        ;
	DRAW_TUTORIAL                                                           ;
	PAUSE_FOR 168                                                           ;
	MENU_SERVICE CLEAR_ALL                                                  ;
	DRAW_MAIN                                                               ;
	WRITE_VPD_AND_TB                                                        ;
	JMP _WAIT	                                                            ;
_MAIN:                                                                      ;
	CMP AL, 32H 															;M - MAIN
	JE _MAIN_                                                               ;
	JMP _VPD                                                                ;
_MAIN_:                                                                     ;
	DRAW_MAIN                                                               ;
	WRITE_VPD_AND_TB                                                        ;
	JMP _WAIT                                                               ;
_VPD:                                                                       ;
	CMP AL, 2FH 															;V - VPD
	JE _VPD_                                                                ;
	JMP _TIME_BASE                                                          ;
_VPD_:                                                                      ;
	INPUT_VPD                                                               ;
	PRINT_WITH_VPD                                                          ;
	JMP _WAIT                                                               ;
_TIME_BASE:                                                                 ;
	CMP AL, 14H 															;T - TIME BASE
	JE _TIME_BASE_                                                          ;
	JMP _ADD_EXISTING                                                       ;
_TIME_BASE_:                                                                ;
	INPUT_TB                                                                ;
	PRINT_WITH_VPD                                                          ;
	JMP _WAIT                                                               ;
_ADD_EXISTING:                                                              ;
	CMP AL, 1EH 															;A - ADD TO EXISTING
	JE _ADD_EXISTING_                                                       ;
	JMP _ADD_NEW                                                            ;
_ADD_EXISTING_:                                                             ;
	INPUT_SINE                                                              ;
	PRINT_WITH_VPD                                                          ;
	JMP _WAIT                                                               ;
_ADD_NEW:                                                                   ;
	CMP AL, 31H 															;N - ADD TO CLEAR SCREEN
	JE _ADD_NEW_                                                            ;
	JMP _WAIT                                                               ;
_ADD_NEW_:                                                                  ;
	PLACE_SINE_ON_BLANK                                                     ;
	INPUT_SINE                                                              ;
	PRINT_WITH_VPD	                                                        ;
	JMP _WAIT                                                               ;
	                                                                        ;
;========================================= END OF MAIN =====================;
;===========================================================================;
                                                                            ;
EXIT:                                                                       ;
                                                                            ;
;==========================                                                 ;
	MOV AX, 03H                                                             ;
	INT 10H																	;RETURN TO REGULAR SMALL SCREEN
	                                                                        ;
	MOV AX, 4C00H                                                           ;
	INT 21H                                                                 ;
;==========================                                                 ;
	                                                                        ;
END START                                                                   ;
                                                                            ;
;===========================================================================;
;===========================================================================;
;                                                                           ;
;                                 _                                         ;
;                              ==(W{==========-      /===-                  ;
;                                ||  (.--.)         /===-_---~~~~~~~----__  ;
;                                | \_,|**|,__      |===-~___            _,-';
;                   -==\\        `\ ' `--'   ),    `//~\\   ~~~~`--._.-~    ;
;               ______-==|        /`\_. .__/\ \    | |  \\          _-~`    ;
;         __--~~~  ,-/-==\\      (   | .  |~~~~|   | |   `\       ,'        ;
;      _-~       /'    |  \\     )__/==0==-\<>/   / /      \     /          ;
;    .'        /       |   \\      /~\___/~~\/  /' /        \   /           ;
;   /  ____  /         |    \`\.__/-~~   \  |_/'  /          \/'            ;
;  /-'~    ~~~~~---__  |     ~-/~         ( )   /'        _--~`             ;
;                    \_|      /        _) | ;  ),   __--~~                  ;
;                      '~~--_/      _-~/- |/ \   '-~ \                      ;
;                     {\__--_/}    / \\_>-|)<__\      \                     ;
;                     /'   (_/  _-~  | |__>--<__|      |                    ;
;                    |   _/) )-~     | |__>--<__|      |                    ;
;                    / /~ ,_/       / /__>---<__/      |                    ;
;                   O-O _//        /-~_>---<__-~      /                     ;
;                   (^(~          /~_>---<__-      _-~                      ;
;                  ,/|           /__>--<__/     _-~                         ;
;               ,//('(          |__>--<__|     /                  .--_      ;
;              ( ( '))          |__>--<__|    |                 /' _-_~\    ;
;           `-)) )) (           |__>--<__|    | 			  /'  /   ~\`\  ;
;          ,/,'//( (             \__>--<__\    \            /'  //      ||  ;
;        ,( ( ((, ))              ~-__>--<_~-_  ~--__---~'/'/  /'       VV  ;
;      `~/  )` ) ,/|                 ~-_~>--<_/-__      __-~ _/             ;
;    ._-~//( )/ )) `                    ~~-'_/_/ /~~~~~__--~                ;
;     ;'( ')/ ,)(                              ~~~~~~~~                     ;
;    ' ') '( (/                                                             ;
;                                                                           ;
;                                                                           ;
;===========================================================================;