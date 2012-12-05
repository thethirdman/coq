exception Error

type token = 
  | STARTVERNAC
  | STARTVERBATIM
  | STARTPP
  | STARTDOC
  | STARTCOM
  | SECTION of (
# 5 "parser.mly"
       (int*string)
# 13 "parser.ml"
)
  | QUERY of (
# 7 "parser.mly"
       (string*string)
# 18 "parser.ml"
)
  | LST of (
# 4 "parser.mly"
       (int)
# 23 "parser.ml"
)
  | LATEX_MATH
  | LATEX
  | ITEM
  | HTML
  | HRULE
  | EOF
  | ENDVERNAC
  | ENDVERBATIM
  | ENDPP
  | ENDLST
  | ENDCOM
  | EMPHASIS
  | CONTENT of (
# 6 "parser.mly"
       (string)
# 40 "parser.ml"
)

and _menhir_env = {
  _menhir_lexer: Lexing.lexbuf -> token;
  _menhir_lexbuf: Lexing.lexbuf;
  mutable _menhir_token: token;
  mutable _menhir_startp: Lexing.position;
  mutable _menhir_endp: Lexing.position;
  mutable _menhir_shifted: int
}

and _menhir_state = 
  | MenhirState51
  | MenhirState47
  | MenhirState41
  | MenhirState38
  | MenhirState26
  | MenhirState25
  | MenhirState24
  | MenhirState16
  | MenhirState12
  | MenhirState6
  | MenhirState2
  | MenhirState1


# 13 "parser.mly"
  
  open Str
  let merge_contents lst = List.fold_right (fun a b -> a^b) lst ""

# 72 "parser.ml"
let _eRR =
  Error

let rec _menhir_goto_parse_lst : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_parse_lst -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv255 * _menhir_state * 'tv_parse_lst) = Obj.magic _menhir_stack in
    ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
    let _tok = _menhir_env._menhir_token in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv253 * _menhir_state * 'tv_parse_lst) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ITEM ->
        _menhir_run26 _menhir_env (Obj.magic _menhir_stack) MenhirState41
    | LST _v ->
        _menhir_run25 _menhir_env (Obj.magic _menhir_stack) MenhirState41 _v
    | ENDLST ->
        _menhir_reduce4 _menhir_env (Obj.magic _menhir_stack) MenhirState41
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState41) : 'freshtv254)) : 'freshtv256)

and _menhir_goto_list_parse_lst_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_parse_lst_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState41 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv231 * _menhir_state * 'tv_parse_lst) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv229 * _menhir_state * 'tv_parse_lst) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, x), _, xs) = _menhir_stack in
        let _v : 'tv_list_parse_lst_ = 
# 116 "/home/yann/usr/share/menhir/standard.mly"
    ( x :: xs )
# 111 "parser.ml"
         in
        _menhir_goto_list_parse_lst_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv230)) : 'freshtv232)
    | MenhirState25 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv241 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 119 "parser.ml"
        )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv239 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 127 "parser.ml"
        )) * _menhir_state * 'tv_list_parse_lst_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDLST ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv235 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 136 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv233 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 143 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s, _), _, lst) = _menhir_stack in
            let _v : 'tv_parse_lst = 
# 45 "parser.mly"
  (`List lst)
# 149 "parser.ml"
             in
            _menhir_goto_parse_lst _menhir_env _menhir_stack _menhir_s _v) : 'freshtv234)) : 'freshtv236)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv237 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 159 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv238)) : 'freshtv240)) : 'freshtv242)
    | MenhirState24 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv251 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 168 "parser.ml"
        )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv249 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 176 "parser.ml"
        )) * _menhir_state * 'tv_list_parse_lst_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDLST ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv245 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 185 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv243 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 192 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s, _), _, lst) = _menhir_stack in
            let _v : 'tv_parse_seq = 
# 41 "parser.mly"
    (`List lst)
# 198 "parser.ml"
             in
            _menhir_goto_parse_seq _menhir_env _menhir_stack _menhir_s _v) : 'freshtv244)) : 'freshtv246)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv247 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 208 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv248)) : 'freshtv250)) : 'freshtv252)
    | _ ->
        _menhir_fail ()

and _menhir_goto_list_parse_term_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_parse_term_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState38 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv213 * _menhir_state * 'tv_parse_term) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv211 * _menhir_state * 'tv_parse_term) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, x), _, xs) = _menhir_stack in
        let _v : 'tv_list_parse_term_ = 
# 116 "/home/yann/usr/share/menhir/standard.mly"
    ( x :: xs )
# 228 "parser.ml"
         in
        _menhir_goto_list_parse_term_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv212)) : 'freshtv214)
    | MenhirState26 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv217 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv215 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _, c) = _menhir_stack in
        let _v : 'tv_parse_lst = 
# 47 "parser.mly"
  ((`Item  (0,`Seq c)) )
# 240 "parser.ml"
         in
        _menhir_goto_parse_lst _menhir_env _menhir_stack _menhir_s _v) : 'freshtv216)) : 'freshtv218)
    | MenhirState47 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv227 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv225 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | EMPHASIS ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv221 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv219 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _, lst) = _menhir_stack in
            let _v : 'tv_parse_seq = 
# 39 "parser.mly"
    (`Emphasis (`Seq lst))
# 262 "parser.ml"
             in
            _menhir_goto_parse_seq _menhir_env _menhir_stack _menhir_s _v) : 'freshtv220)) : 'freshtv222)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv223 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv224)) : 'freshtv226)) : 'freshtv228)
    | _ ->
        _menhir_fail ()

and _menhir_fail : unit -> 'a =
  fun () ->
    Printf.fprintf Pervasives.stderr "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

and _menhir_goto_parse_seq : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_parse_seq -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv209 * _menhir_state * 'tv_parse_seq) = Obj.magic _menhir_stack in
    ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
    let _tok = _menhir_env._menhir_token in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv207 * _menhir_state * 'tv_parse_seq) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        _menhir_run37 _menhir_env (Obj.magic _menhir_stack) MenhirState51 _v
    | EMPHASIS ->
        _menhir_run47 _menhir_env (Obj.magic _menhir_stack) MenhirState51
    | HRULE ->
        _menhir_run36 _menhir_env (Obj.magic _menhir_stack) MenhirState51
    | HTML ->
        _menhir_run33 _menhir_env (Obj.magic _menhir_stack) MenhirState51
    | LATEX ->
        _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState51
    | LATEX_MATH ->
        _menhir_run27 _menhir_env (Obj.magic _menhir_stack) MenhirState51
    | LST _v ->
        _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState51 _v
    | QUERY _v ->
        _menhir_run23 _menhir_env (Obj.magic _menhir_stack) MenhirState51 _v
    | SECTION _v ->
        _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState51 _v
    | STARTPP ->
        _menhir_run19 _menhir_env (Obj.magic _menhir_stack) MenhirState51
    | STARTVERBATIM ->
        _menhir_run16 _menhir_env (Obj.magic _menhir_stack) MenhirState51
    | STARTVERNAC ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState51
    | EOF ->
        _menhir_reduce6 _menhir_env (Obj.magic _menhir_stack) MenhirState51
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState51) : 'freshtv208)) : 'freshtv210)

and _menhir_goto_list_CONTENT_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_CONTENT_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState2 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv175 * _menhir_state * (
# 6 "parser.mly"
       (string)
# 331 "parser.ml"
        )) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv173 * _menhir_state * (
# 6 "parser.mly"
       (string)
# 337 "parser.ml"
        )) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, x), _, xs) = _menhir_stack in
        let _v : 'tv_list_CONTENT_ = 
# 116 "/home/yann/usr/share/menhir/standard.mly"
    ( x :: xs )
# 343 "parser.ml"
         in
        _menhir_goto_list_CONTENT_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv174)) : 'freshtv176)
    | MenhirState1 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv185) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv183) * _menhir_state * 'tv_list_CONTENT_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDCOM ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv179) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv177) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _, _2) = _menhir_stack in
            let _v : (
# 10 "parser.mly"
      (string Cst.cst_node)
# 364 "parser.ml"
            ) = 
# 25 "parser.mly"
  (Cst.Doc (merge_contents _2))
# 368 "parser.ml"
             in
            _menhir_goto_main _menhir_env _menhir_stack _v) : 'freshtv178)) : 'freshtv180)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv181) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv182)) : 'freshtv184)) : 'freshtv186)
    | MenhirState6 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv195) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv193) * _menhir_state * 'tv_list_CONTENT_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDCOM ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv189) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv187) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _, _2) = _menhir_stack in
            let _v : (
# 10 "parser.mly"
      (string Cst.cst_node)
# 396 "parser.ml"
            ) = 
# 23 "parser.mly"
  (Cst.Comment (merge_contents _2))
# 400 "parser.ml"
             in
            _menhir_goto_main _menhir_env _menhir_stack _v) : 'freshtv188)) : 'freshtv190)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv191) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv192)) : 'freshtv194)) : 'freshtv196)
    | MenhirState16 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv205 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv203 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDVERBATIM ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv199 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv197 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _, _2) = _menhir_stack in
            let _v : 'tv_parse_term = 
# 55 "parser.mly"
  (`Verbatim (merge_contents _2))
# 429 "parser.ml"
             in
            _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv198)) : 'freshtv200)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv201 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv202)) : 'freshtv204)) : 'freshtv206)
    | _ ->
        _menhir_fail ()

and _menhir_goto_list_parse_seq_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_parse_seq_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState51 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv155 * _menhir_state * 'tv_parse_seq) * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv153 * _menhir_state * 'tv_parse_seq) * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, x), _, xs) = _menhir_stack in
        let _v : 'tv_list_parse_seq_ = 
# 116 "/home/yann/usr/share/menhir/standard.mly"
    ( x :: xs )
# 455 "parser.ml"
         in
        _menhir_goto_list_parse_seq_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv154)) : 'freshtv156)
    | MenhirState12 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv171 * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv169 * _menhir_state * 'tv_list_parse_seq_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | EOF ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv165 * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv163 * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, lst) = _menhir_stack in
            let _v : (
# 11 "parser.mly"
      (Cst.doc)
# 476 "parser.ml"
            ) = 
# 33 "parser.mly"
    (`Seq lst)
# 480 "parser.ml"
             in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv161) = _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : (
# 11 "parser.mly"
      (Cst.doc)
# 488 "parser.ml"
            )) = _v in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv159) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : (
# 11 "parser.mly"
      (Cst.doc)
# 496 "parser.ml"
            )) = _v in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv157) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_1 : (
# 11 "parser.mly"
      (Cst.doc)
# 504 "parser.ml"
            )) = _v in
            (Obj.magic _1 : 'freshtv158)) : 'freshtv160)) : 'freshtv162)) : 'freshtv164)) : 'freshtv166)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv167 * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv168)) : 'freshtv170)) : 'freshtv172)
    | _ ->
        _menhir_fail ()

and _menhir_reduce4 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_parse_lst_ = 
# 114 "/home/yann/usr/share/menhir/standard.mly"
    ( [] )
# 522 "parser.ml"
     in
    _menhir_goto_list_parse_lst_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run25 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 4 "parser.mly"
       (int)
# 529 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv151 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 538 "parser.ml"
    )) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ITEM ->
        _menhir_run26 _menhir_env (Obj.magic _menhir_stack) MenhirState25
    | LST _v ->
        _menhir_run25 _menhir_env (Obj.magic _menhir_stack) MenhirState25 _v
    | ENDLST ->
        _menhir_reduce4 _menhir_env (Obj.magic _menhir_stack) MenhirState25
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState25) : 'freshtv152)

and _menhir_run26 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv149 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        _menhir_run37 _menhir_env (Obj.magic _menhir_stack) MenhirState26 _v
    | HRULE ->
        _menhir_run36 _menhir_env (Obj.magic _menhir_stack) MenhirState26
    | HTML ->
        _menhir_run33 _menhir_env (Obj.magic _menhir_stack) MenhirState26
    | LATEX ->
        _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState26
    | LATEX_MATH ->
        _menhir_run27 _menhir_env (Obj.magic _menhir_stack) MenhirState26
    | QUERY _v ->
        _menhir_run23 _menhir_env (Obj.magic _menhir_stack) MenhirState26 _v
    | SECTION _v ->
        _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState26 _v
    | STARTPP ->
        _menhir_run19 _menhir_env (Obj.magic _menhir_stack) MenhirState26
    | STARTVERBATIM ->
        _menhir_run16 _menhir_env (Obj.magic _menhir_stack) MenhirState26
    | STARTVERNAC ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState26
    | ENDLST | ITEM | LST _ ->
        _menhir_reduce8 _menhir_env (Obj.magic _menhir_stack) MenhirState26
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState26) : 'freshtv150)

and _menhir_reduce8 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_parse_term_ = 
# 114 "/home/yann/usr/share/menhir/standard.mly"
    ( [] )
# 593 "parser.ml"
     in
    _menhir_goto_list_parse_term_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_goto_parse_term : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_parse_term -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState47 | MenhirState38 | MenhirState26 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv143 * _menhir_state * 'tv_parse_term) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv141 * _menhir_state * 'tv_parse_term) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | CONTENT _v ->
            _menhir_run37 _menhir_env (Obj.magic _menhir_stack) MenhirState38 _v
        | HRULE ->
            _menhir_run36 _menhir_env (Obj.magic _menhir_stack) MenhirState38
        | HTML ->
            _menhir_run33 _menhir_env (Obj.magic _menhir_stack) MenhirState38
        | LATEX ->
            _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState38
        | LATEX_MATH ->
            _menhir_run27 _menhir_env (Obj.magic _menhir_stack) MenhirState38
        | QUERY _v ->
            _menhir_run23 _menhir_env (Obj.magic _menhir_stack) MenhirState38 _v
        | SECTION _v ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState38 _v
        | STARTPP ->
            _menhir_run19 _menhir_env (Obj.magic _menhir_stack) MenhirState38
        | STARTVERBATIM ->
            _menhir_run16 _menhir_env (Obj.magic _menhir_stack) MenhirState38
        | STARTVERNAC ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState38
        | EMPHASIS | ENDLST | ITEM | LST _ ->
            _menhir_reduce8 _menhir_env (Obj.magic _menhir_stack) MenhirState38
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState38) : 'freshtv142)) : 'freshtv144)
    | MenhirState51 | MenhirState12 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv147 * _menhir_state * 'tv_parse_term) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv145 * _menhir_state * 'tv_parse_term) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, term) = _menhir_stack in
        let _v : 'tv_parse_seq = 
# 37 "parser.mly"
    (term)
# 645 "parser.ml"
         in
        _menhir_goto_parse_seq _menhir_env _menhir_stack _menhir_s _v) : 'freshtv146)) : 'freshtv148)
    | _ ->
        _menhir_fail ()

and _menhir_reduce2 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_CONTENT_ = 
# 114 "/home/yann/usr/share/menhir/standard.mly"
    ( [] )
# 656 "parser.ml"
     in
    _menhir_goto_list_CONTENT_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run2 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 6 "parser.mly"
       (string)
# 663 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv139 * _menhir_state * (
# 6 "parser.mly"
       (string)
# 672 "parser.ml"
    )) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        _menhir_run2 _menhir_env (Obj.magic _menhir_stack) MenhirState2 _v
    | ENDCOM | ENDVERBATIM ->
        _menhir_reduce2 _menhir_env (Obj.magic _menhir_stack) MenhirState2
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState2) : 'freshtv140)

and _menhir_discard : _menhir_env -> token =
  fun _menhir_env ->
    let lexbuf = _menhir_env._menhir_lexbuf in
    let _tok = _menhir_env._menhir_lexer lexbuf in
    _menhir_env._menhir_token <- _tok;
    _menhir_env._menhir_startp <- lexbuf.Lexing.lex_start_p;
    _menhir_env._menhir_endp <- lexbuf.Lexing.lex_curr_p;
    let shifted = Pervasives.(+) _menhir_env._menhir_shifted 1 in
    if Pervasives.(>=) shifted 0 then
      _menhir_env._menhir_shifted <- shifted;
    _tok

and _menhir_goto_main : _menhir_env -> 'ttv_tail -> (
# 10 "parser.mly"
      (string Cst.cst_node)
# 700 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _v ->
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv137) = Obj.magic _menhir_stack in
    let (_v : (
# 10 "parser.mly"
      (string Cst.cst_node)
# 708 "parser.ml"
    )) = _v in
    ((let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv135) = Obj.magic _menhir_stack in
    let (_1 : (
# 10 "parser.mly"
      (string Cst.cst_node)
# 715 "parser.ml"
    )) = _v in
    (Obj.magic _1 : 'freshtv136)) : 'freshtv138)

and _menhir_errorcase : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    match _menhir_s with
    | MenhirState51 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv111 * _menhir_state * 'tv_parse_seq) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv112)
    | MenhirState47 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv113 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv114)
    | MenhirState41 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv115 * _menhir_state * 'tv_parse_lst) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv116)
    | MenhirState38 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv117 * _menhir_state * 'tv_parse_term) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv118)
    | MenhirState26 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv119 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv120)
    | MenhirState25 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv121 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 752 "parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv122)
    | MenhirState24 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv123 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 761 "parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv124)
    | MenhirState16 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv125 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv126)
    | MenhirState12 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv127) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv128)
    | MenhirState6 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv129) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv130)
    | MenhirState2 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv131 * _menhir_state * (
# 6 "parser.mly"
       (string)
# 783 "parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv132)
    | MenhirState1 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv133) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv134)

and _menhir_reduce6 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_parse_seq_ = 
# 114 "/home/yann/usr/share/menhir/standard.mly"
    ( [] )
# 797 "parser.ml"
     in
    _menhir_goto_list_parse_seq_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run13 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv109 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv105 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 6 "parser.mly"
       (string)
# 815 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv103 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 823 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDVERNAC ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv99 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 832 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv97 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 839 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_parse_term = 
# 51 "parser.mly"
  (`Vernac _2)
# 845 "parser.ml"
             in
            _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv98)) : 'freshtv100)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv101 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 855 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv102)) : 'freshtv104)) : 'freshtv106)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv107 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv108)) : 'freshtv110)

and _menhir_run16 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv95 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        _menhir_run2 _menhir_env (Obj.magic _menhir_stack) MenhirState16 _v
    | ENDVERBATIM ->
        _menhir_reduce2 _menhir_env (Obj.magic _menhir_stack) MenhirState16
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState16) : 'freshtv96)

and _menhir_run19 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv93 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv89 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 6 "parser.mly"
       (string)
# 898 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv87 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 906 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDPP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv83 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 915 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv81 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 922 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_parse_term = 
# 53 "parser.mly"
  (`Pretty_print _2)
# 928 "parser.ml"
             in
            _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv82)) : 'freshtv84)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv85 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 938 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv86)) : 'freshtv88)) : 'freshtv90)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv91 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv92)) : 'freshtv94)

and _menhir_run22 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 5 "parser.mly"
       (int*string)
# 953 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv79) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (_1 : (
# 5 "parser.mly"
       (int*string)
# 963 "parser.ml"
    )) = _v in
    ((let _v : 'tv_parse_term = 
# 57 "parser.mly"
  (`Section _1)
# 968 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv80)

and _menhir_run23 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 7 "parser.mly"
       (string*string)
# 975 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv77) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (query : (
# 7 "parser.mly"
       (string*string)
# 985 "parser.ml"
    )) = _v in
    ((let _v : 'tv_parse_term = 
# 69 "parser.mly"
  (let (name,arglist) = query in `Query (name,(Str.split (Str.regexp ",")
  arglist)))
# 991 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv78)

and _menhir_run24 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 4 "parser.mly"
       (int)
# 998 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv75 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 1007 "parser.ml"
    )) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ITEM ->
        _menhir_run26 _menhir_env (Obj.magic _menhir_stack) MenhirState24
    | LST _v ->
        _menhir_run25 _menhir_env (Obj.magic _menhir_stack) MenhirState24 _v
    | ENDLST ->
        _menhir_reduce4 _menhir_env (Obj.magic _menhir_stack) MenhirState24
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState24) : 'freshtv76)

and _menhir_run27 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv73 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv69 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 6 "parser.mly"
       (string)
# 1036 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv67 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1044 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | LATEX_MATH ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv63 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1053 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv61 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1060 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_parse_term = 
# 63 "parser.mly"
  (`Raw {Cst.latex = ""; Cst.latex_math=_2; Cst.html="";})
# 1066 "parser.ml"
             in
            _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv62)) : 'freshtv64)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv65 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1076 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv66)) : 'freshtv68)) : 'freshtv70)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv71 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv72)) : 'freshtv74)

and _menhir_run30 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv59 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv55 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 6 "parser.mly"
       (string)
# 1102 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv53 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1110 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | LATEX ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv49 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1119 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv47 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1126 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_parse_term = 
# 61 "parser.mly"
  (`Raw {Cst.latex = _2; Cst.latex_math=""; Cst.html="";})
# 1132 "parser.ml"
             in
            _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv48)) : 'freshtv50)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv51 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1142 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv52)) : 'freshtv54)) : 'freshtv56)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv57 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv58)) : 'freshtv60)

and _menhir_run33 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv45 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv41 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 6 "parser.mly"
       (string)
# 1168 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv39 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1176 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | HTML ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv35 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1185 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv33 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1192 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_parse_term = 
# 65 "parser.mly"
  (`Raw {Cst.latex = ""; Cst.latex_math=""; Cst.html=_2;})
# 1198 "parser.ml"
             in
            _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv34)) : 'freshtv36)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv37 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1208 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv38)) : 'freshtv40)) : 'freshtv42)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv43 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv44)) : 'freshtv46)

and _menhir_run36 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv31) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    ((let _v : 'tv_parse_term = 
# 59 "parser.mly"
  (`Hrule)
# 1229 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv32)

and _menhir_run47 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv29 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        _menhir_run37 _menhir_env (Obj.magic _menhir_stack) MenhirState47 _v
    | HRULE ->
        _menhir_run36 _menhir_env (Obj.magic _menhir_stack) MenhirState47
    | HTML ->
        _menhir_run33 _menhir_env (Obj.magic _menhir_stack) MenhirState47
    | LATEX ->
        _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState47
    | LATEX_MATH ->
        _menhir_run27 _menhir_env (Obj.magic _menhir_stack) MenhirState47
    | QUERY _v ->
        _menhir_run23 _menhir_env (Obj.magic _menhir_stack) MenhirState47 _v
    | SECTION _v ->
        _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState47 _v
    | STARTPP ->
        _menhir_run19 _menhir_env (Obj.magic _menhir_stack) MenhirState47
    | STARTVERBATIM ->
        _menhir_run16 _menhir_env (Obj.magic _menhir_stack) MenhirState47
    | STARTVERNAC ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState47
    | EMPHASIS ->
        _menhir_reduce8 _menhir_env (Obj.magic _menhir_stack) MenhirState47
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState47) : 'freshtv30)

and _menhir_run37 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 6 "parser.mly"
       (string)
# 1271 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv27) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (_1 : (
# 6 "parser.mly"
       (string)
# 1281 "parser.ml"
    )) = _v in
    ((let _v : 'tv_parse_term = 
# 67 "parser.mly"
  (`Content _1)
# 1286 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv28)

and _menhir_init : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> _menhir_env =
  fun lexer lexbuf ->
    let _tok = lexer lexbuf in
    {
      _menhir_lexer = lexer;
      _menhir_lexbuf = lexbuf;
      _menhir_token = _tok;
      _menhir_startp = lexbuf.Lexing.lex_start_p;
      _menhir_endp = lexbuf.Lexing.lex_curr_p;
      _menhir_shifted = 4611686018427387903;
      }

and main : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (
# 10 "parser.mly"
      (string Cst.cst_node)
# 1305 "parser.ml"
) =
  fun lexer lexbuf ->
    let _menhir_env = _menhir_init lexer lexbuf in
    Obj.magic (let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv25) = () in
    ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
    let _tok = _menhir_env._menhir_token in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv23) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv7) = Obj.magic _menhir_stack in
        let (_v : (
# 6 "parser.mly"
       (string)
# 1323 "parser.ml"
        )) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv5) = Obj.magic _menhir_stack in
        let (_1 : (
# 6 "parser.mly"
       (string)
# 1330 "parser.ml"
        )) = _v in
        ((let _v : (
# 10 "parser.mly"
      (string Cst.cst_node)
# 1335 "parser.ml"
        ) = 
# 27 "parser.mly"
  (Cst.Code _1 )
# 1339 "parser.ml"
         in
        _menhir_goto_main _menhir_env _menhir_stack _v) : 'freshtv6)) : 'freshtv8)
    | EOF ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv11) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv9) = Obj.magic _menhir_stack in
        ((let _v : (
# 10 "parser.mly"
      (string Cst.cst_node)
# 1350 "parser.ml"
        ) = 
# 29 "parser.mly"
  (raise Cst.End_of_file)
# 1354 "parser.ml"
         in
        _menhir_goto_main _menhir_env _menhir_stack _v) : 'freshtv10)) : 'freshtv12)
    | STARTCOM ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv15) = Obj.magic _menhir_stack in
        ((let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv13) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | CONTENT _v ->
            _menhir_run2 _menhir_env (Obj.magic _menhir_stack) MenhirState6 _v
        | ENDCOM ->
            _menhir_reduce2 _menhir_env (Obj.magic _menhir_stack) MenhirState6
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState6) : 'freshtv14)) : 'freshtv16)
    | STARTDOC ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv19) = Obj.magic _menhir_stack in
        ((let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv17) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | CONTENT _v ->
            _menhir_run2 _menhir_env (Obj.magic _menhir_stack) MenhirState1 _v
        | ENDCOM ->
            _menhir_reduce2 _menhir_env (Obj.magic _menhir_stack) MenhirState1
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState1) : 'freshtv18)) : 'freshtv20)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv21) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv22)) : 'freshtv24)) : 'freshtv26))

and parse_doc : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (
# 11 "parser.mly"
      (Cst.doc)
# 1399 "parser.ml"
) =
  fun lexer lexbuf ->
    let _menhir_env = _menhir_init lexer lexbuf in
    Obj.magic (let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv3) = () in
    ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
    let _tok = _menhir_env._menhir_token in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv1) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        _menhir_run37 _menhir_env (Obj.magic _menhir_stack) MenhirState12 _v
    | EMPHASIS ->
        _menhir_run47 _menhir_env (Obj.magic _menhir_stack) MenhirState12
    | HRULE ->
        _menhir_run36 _menhir_env (Obj.magic _menhir_stack) MenhirState12
    | HTML ->
        _menhir_run33 _menhir_env (Obj.magic _menhir_stack) MenhirState12
    | LATEX ->
        _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState12
    | LATEX_MATH ->
        _menhir_run27 _menhir_env (Obj.magic _menhir_stack) MenhirState12
    | LST _v ->
        _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState12 _v
    | QUERY _v ->
        _menhir_run23 _menhir_env (Obj.magic _menhir_stack) MenhirState12 _v
    | SECTION _v ->
        _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState12 _v
    | STARTPP ->
        _menhir_run19 _menhir_env (Obj.magic _menhir_stack) MenhirState12
    | STARTVERBATIM ->
        _menhir_run16 _menhir_env (Obj.magic _menhir_stack) MenhirState12
    | STARTVERNAC ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState12
    | EOF ->
        _menhir_reduce6 _menhir_env (Obj.magic _menhir_stack) MenhirState12
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState12) : 'freshtv2)) : 'freshtv4))



