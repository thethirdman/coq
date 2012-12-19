exception Error

type token = 
  | STARTVERNAC
  | STARTVERBATIM
  | STARTPP
  | STARTDOC
  | STARTCOM
  | SECTION of (
# 7 "parser.mly"
       (int*string)
# 13 "parser.ml"
)
  | RM_PRINTING of (
# 8 "parser.mly"
       (string)
# 18 "parser.ml"
)
  | QUERY of (
# 10 "parser.mly"
       (string*string)
# 23 "parser.ml"
)
  | LST of (
# 6 "parser.mly"
       (int)
# 28 "parser.ml"
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
# 8 "parser.mly"
       (string)
# 45 "parser.ml"
)
  | ADD_PRINTING of (
# 9 "parser.mly"
       (bool*string)
# 50 "parser.ml"
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
  | MenhirState54
  | MenhirState51
  | MenhirState43
  | MenhirState40
  | MenhirState35
  | MenhirState30
  | MenhirState29
  | MenhirState27
  | MenhirState16
  | MenhirState15
  | MenhirState5
  | MenhirState4
  | MenhirState0


# 17 "parser.mly"
  
  open Str
  let merge_contents lst = List.fold_right (fun a b -> a^b) lst ""

  (** Merges a list of Cst.raw_content elements. The last non-empty fields
   * encountered are kept *)
  let merge_raw_content lst =
    let open Cst in List.fold_left (fun acc item ->
    { latex =
          if item.latex <> "" then item.latex else acc.latex;
      latex_math =
        if item.latex_math <> "" then item.latex_math else acc.latex_math;
      html =
        if item.html <> "" then item.html else acc.html;
      default =
        if item.default <> "" then item.default else acc.default})
    {latex = ""; latex_math = ""; html = ""; default= ""} lst

# 97 "parser.ml"
let _eRR =
  Error

let rec _menhir_goto_list_parse_lst_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_parse_lst_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState43 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv263 * _menhir_state * 'tv_parse_lst) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv261 * _menhir_state * 'tv_parse_lst) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, x), _, xs) = _menhir_stack in
        let _v : 'tv_list_parse_lst_ = 
# 116 "/usr/local/share/menhir/standard.mly"
    ( x :: xs )
# 114 "parser.ml"
         in
        _menhir_goto_list_parse_lst_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv262)) : 'freshtv264)
    | MenhirState15 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv273 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 122 "parser.ml"
        )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv271 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 130 "parser.ml"
        )) * _menhir_state * 'tv_list_parse_lst_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDLST ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv267 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 139 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv265 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 146 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s, _), _, lst) = _menhir_stack in
            let _v : 'tv_parse_seq = 
# 65 "parser.mly"
    (`List lst)
# 152 "parser.ml"
             in
            _menhir_goto_parse_seq _menhir_env _menhir_stack _menhir_s _v) : 'freshtv266)) : 'freshtv268)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv269 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 162 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv270)) : 'freshtv272)) : 'freshtv274)
    | _ ->
        _menhir_fail ()

and _menhir_goto_list_parse_term_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_parse_term_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState35 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv249 * _menhir_state * 'tv_parse_term) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv247 * _menhir_state * 'tv_parse_term) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, x), _, xs) = _menhir_stack in
        let _v : 'tv_list_parse_term_ = 
# 116 "/usr/local/share/menhir/standard.mly"
    ( x :: xs )
# 182 "parser.ml"
         in
        _menhir_goto_list_parse_term_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv248)) : 'freshtv250)
    | MenhirState27 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv259 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv257 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | EMPHASIS ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv253 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv251 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _, lst) = _menhir_stack in
            let _v : 'tv_parse_seq = 
# 63 "parser.mly"
    (`Emphasis (`Seq lst))
# 204 "parser.ml"
             in
            _menhir_goto_parse_seq _menhir_env _menhir_stack _menhir_s _v) : 'freshtv252)) : 'freshtv254)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv255 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv256)) : 'freshtv258)) : 'freshtv260)
    | _ ->
        _menhir_fail ()

and _menhir_goto_parse_seq : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_parse_seq -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv245 * _menhir_state * 'tv_parse_seq) = Obj.magic _menhir_stack in
    ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
    let _tok = _menhir_env._menhir_token in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv243 * _menhir_state * 'tv_parse_seq) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ADD_PRINTING _v ->
        _menhir_run29 _menhir_env (Obj.magic _menhir_stack) MenhirState40 _v
    | CONTENT _v ->
        _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState40 _v
    | EMPHASIS ->
        _menhir_run27 _menhir_env (Obj.magic _menhir_stack) MenhirState40
    | HRULE ->
        _menhir_run26 _menhir_env (Obj.magic _menhir_stack) MenhirState40
    | HTML ->
        _menhir_run23 _menhir_env (Obj.magic _menhir_stack) MenhirState40
    | LATEX ->
        _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState40
    | LATEX_MATH ->
        _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState40
    | LST _v ->
        _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState40 _v
    | QUERY _v ->
        _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState40 _v
    | RM_PRINTING _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState40 _v
    | SECTION _v ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState40 _v
    | STARTPP ->
        _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState40
    | STARTVERBATIM ->
        _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState40
    | STARTVERNAC ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState40
    | ENDLST | EOF | ITEM ->
        _menhir_reduce6 _menhir_env (Obj.magic _menhir_stack) MenhirState40
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState40) : 'freshtv244)) : 'freshtv246)

and _menhir_goto_list_raw_terms_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_raw_terms_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState30 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv231 * _menhir_state * 'tv_raw_terms) * _menhir_state * 'tv_list_raw_terms_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv229 * _menhir_state * 'tv_raw_terms) * _menhir_state * 'tv_list_raw_terms_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, x), _, xs) = _menhir_stack in
        let _v : 'tv_list_raw_terms_ = 
# 116 "/usr/local/share/menhir/standard.mly"
    ( x :: xs )
# 276 "parser.ml"
         in
        _menhir_goto_list_raw_terms_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv230)) : 'freshtv232)
    | MenhirState29 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv241 * _menhir_state * (
# 9 "parser.mly"
       (bool*string)
# 284 "parser.ml"
        )) * _menhir_state * 'tv_list_raw_terms_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv239 * _menhir_state * (
# 9 "parser.mly"
       (bool*string)
# 292 "parser.ml"
        )) * _menhir_state * 'tv_list_raw_terms_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | EOF ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv235 * _menhir_state * (
# 9 "parser.mly"
       (bool*string)
# 301 "parser.ml"
            )) * _menhir_state * 'tv_list_raw_terms_) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv233 * _menhir_state * (
# 9 "parser.mly"
       (bool*string)
# 308 "parser.ml"
            )) * _menhir_state * 'tv_list_raw_terms_) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s, _1), _, translations) = _menhir_stack in
            let _v : 'tv_parse_term = 
# 90 "parser.mly"
( let open Cst in
  let final_translation = (merge_raw_content translations) in
  `Add_printing {is_command = (fst _1); match_element = (snd _1);
  replace_with = {latex = final_translation.latex; html =
    final_translation.html; latex_math = final_translation.latex_math;
    default = (snd _1)}}
)
# 320 "parser.ml"
             in
            _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv234)) : 'freshtv236)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv237 * _menhir_state * (
# 9 "parser.mly"
       (bool*string)
# 330 "parser.ml"
            )) * _menhir_state * 'tv_list_raw_terms_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv238)) : 'freshtv240)) : 'freshtv242)
    | _ ->
        _menhir_fail ()

and _menhir_fail : unit -> 'a =
  fun () ->
    Printf.fprintf Pervasives.stderr "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

and _menhir_goto_list_parse_seq_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_parse_seq_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState40 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv201 * _menhir_state * 'tv_parse_seq) * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv199 * _menhir_state * 'tv_parse_seq) * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, x), _, xs) = _menhir_stack in
        let _v : 'tv_list_parse_seq_ = 
# 116 "/usr/local/share/menhir/standard.mly"
    ( x :: xs )
# 355 "parser.ml"
         in
        _menhir_goto_list_parse_seq_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv200)) : 'freshtv202)
    | MenhirState16 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv211 * _menhir_state) * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv209 * _menhir_state) * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _, c) = _menhir_stack in
        let _v : 'tv_parse_lst = 
# 70 "parser.mly"
  (`Item  (`Seq c) )
# 367 "parser.ml"
         in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv207) = _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_parse_lst) = _v in
        ((let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv205 * _menhir_state * 'tv_parse_lst) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv203 * _menhir_state * 'tv_parse_lst) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ITEM ->
            _menhir_run16 _menhir_env (Obj.magic _menhir_stack) MenhirState43
        | ENDLST ->
            _menhir_reduce4 _menhir_env (Obj.magic _menhir_stack) MenhirState43
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState43) : 'freshtv204)) : 'freshtv206)) : 'freshtv208)) : 'freshtv210)) : 'freshtv212)
    | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv227 * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv225 * _menhir_state * 'tv_list_parse_seq_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | EOF ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv221 * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv219 * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, lst) = _menhir_stack in
            let _v : (
# 15 "parser.mly"
      (Cst.doc_with_eval)
# 408 "parser.ml"
            ) = 
# 55 "parser.mly"
    (`Seq lst)
# 412 "parser.ml"
             in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv217) = _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : (
# 15 "parser.mly"
      (Cst.doc_with_eval)
# 420 "parser.ml"
            )) = _v in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv215) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : (
# 15 "parser.mly"
      (Cst.doc_with_eval)
# 428 "parser.ml"
            )) = _v in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv213) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_1 : (
# 15 "parser.mly"
      (Cst.doc_with_eval)
# 436 "parser.ml"
            )) = _v in
            (Obj.magic _1 : 'freshtv214)) : 'freshtv216)) : 'freshtv218)) : 'freshtv220)) : 'freshtv222)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv223 * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv224)) : 'freshtv226)) : 'freshtv228)
    | _ ->
        _menhir_fail ()

and _menhir_reduce4 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_parse_lst_ = 
# 114 "/usr/local/share/menhir/standard.mly"
    ( [] )
# 454 "parser.ml"
     in
    _menhir_goto_list_parse_lst_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run16 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv197 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ADD_PRINTING _v ->
        _menhir_run29 _menhir_env (Obj.magic _menhir_stack) MenhirState16 _v
    | CONTENT _v ->
        _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState16 _v
    | EMPHASIS ->
        _menhir_run27 _menhir_env (Obj.magic _menhir_stack) MenhirState16
    | HRULE ->
        _menhir_run26 _menhir_env (Obj.magic _menhir_stack) MenhirState16
    | HTML ->
        _menhir_run23 _menhir_env (Obj.magic _menhir_stack) MenhirState16
    | LATEX ->
        _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState16
    | LATEX_MATH ->
        _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState16
    | LST _v ->
        _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState16 _v
    | QUERY _v ->
        _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState16 _v
    | RM_PRINTING _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState16 _v
    | SECTION _v ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState16 _v
    | STARTPP ->
        _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState16
    | STARTVERBATIM ->
        _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState16
    | STARTVERNAC ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState16
    | ENDLST | ITEM ->
        _menhir_reduce6 _menhir_env (Obj.magic _menhir_stack) MenhirState16
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState16) : 'freshtv198)

and _menhir_goto_raw_terms : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_raw_terms -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState30 | MenhirState29 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv191 * _menhir_state * 'tv_raw_terms) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv189 * _menhir_state * 'tv_raw_terms) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | HTML ->
            _menhir_run23 _menhir_env (Obj.magic _menhir_stack) MenhirState30
        | LATEX ->
            _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState30
        | LATEX_MATH ->
            _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState30
        | EOF ->
            _menhir_reduce10 _menhir_env (Obj.magic _menhir_stack) MenhirState30
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState30) : 'freshtv190)) : 'freshtv192)
    | MenhirState0 | MenhirState40 | MenhirState16 | MenhirState35 | MenhirState27 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv195 * _menhir_state * 'tv_raw_terms) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv193 * _menhir_state * 'tv_raw_terms) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _1) = _menhir_stack in
        let _v : 'tv_parse_term = 
# 100 "parser.mly"
  (`Raw _1)
# 535 "parser.ml"
         in
        _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv194)) : 'freshtv196)
    | _ ->
        _menhir_fail ()

and _menhir_reduce8 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_parse_term_ = 
# 114 "/usr/local/share/menhir/standard.mly"
    ( [] )
# 546 "parser.ml"
     in
    _menhir_goto_list_parse_term_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_goto_parse_term : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_parse_term -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState35 | MenhirState27 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv183 * _menhir_state * 'tv_parse_term) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv181 * _menhir_state * 'tv_parse_term) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ADD_PRINTING _v ->
            _menhir_run29 _menhir_env (Obj.magic _menhir_stack) MenhirState35 _v
        | CONTENT _v ->
            _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState35 _v
        | HRULE ->
            _menhir_run26 _menhir_env (Obj.magic _menhir_stack) MenhirState35
        | HTML ->
            _menhir_run23 _menhir_env (Obj.magic _menhir_stack) MenhirState35
        | LATEX ->
            _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState35
        | LATEX_MATH ->
            _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState35
        | QUERY _v ->
            _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState35 _v
        | RM_PRINTING _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState35 _v
        | SECTION _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState35 _v
        | STARTPP ->
            _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState35
        | STARTVERBATIM ->
            _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState35
        | STARTVERNAC ->
            _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState35
        | EMPHASIS ->
            _menhir_reduce8 _menhir_env (Obj.magic _menhir_stack) MenhirState35
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState35) : 'freshtv182)) : 'freshtv184)
    | MenhirState0 | MenhirState40 | MenhirState16 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv187 * _menhir_state * 'tv_parse_term) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv185 * _menhir_state * 'tv_parse_term) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, term) = _menhir_stack in
        let _v : 'tv_parse_seq = 
# 61 "parser.mly"
    (term)
# 602 "parser.ml"
         in
        _menhir_goto_parse_seq _menhir_env _menhir_stack _menhir_s _v) : 'freshtv186)) : 'freshtv188)
    | _ ->
        _menhir_fail ()

and _menhir_reduce10 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_raw_terms_ = 
# 114 "/usr/local/share/menhir/standard.mly"
    ( [] )
# 613 "parser.ml"
     in
    _menhir_goto_list_raw_terms_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_goto_list_CONTENT_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_CONTENT_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState5 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv149 * _menhir_state * (
# 8 "parser.mly"
       (string)
# 626 "parser.ml"
        )) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv147 * _menhir_state * (
# 8 "parser.mly"
       (string)
# 632 "parser.ml"
        )) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, x), _, xs) = _menhir_stack in
        let _v : 'tv_list_CONTENT_ = 
# 116 "/usr/local/share/menhir/standard.mly"
    ( x :: xs )
# 638 "parser.ml"
         in
        _menhir_goto_list_CONTENT_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv148)) : 'freshtv150)
    | MenhirState4 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv159 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv157 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDVERBATIM ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv153 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv151 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _, _2) = _menhir_stack in
            let _v : 'tv_parse_term = 
# 79 "parser.mly"
  (`Verbatim (merge_contents _2))
# 660 "parser.ml"
             in
            _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv152)) : 'freshtv154)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv155 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv156)) : 'freshtv158)) : 'freshtv160)
    | MenhirState51 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv169) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv167) * _menhir_state * 'tv_list_CONTENT_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDCOM ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv163) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv161) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _, _2) = _menhir_stack in
            let _v : (
# 14 "parser.mly"
      ((string,string) Cst.cst_node)
# 688 "parser.ml"
            ) = 
# 45 "parser.mly"
  (Cst.Doc (merge_contents _2))
# 692 "parser.ml"
             in
            _menhir_goto_parse_vernac _menhir_env _menhir_stack _v) : 'freshtv162)) : 'freshtv164)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv165) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv166)) : 'freshtv168)) : 'freshtv170)
    | MenhirState54 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv179) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv177) * _menhir_state * 'tv_list_CONTENT_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDCOM ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv173) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv171) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _, _2) = _menhir_stack in
            let _v : (
# 14 "parser.mly"
      ((string,string) Cst.cst_node)
# 720 "parser.ml"
            ) = 
# 43 "parser.mly"
  (Cst.Comment (merge_contents _2))
# 724 "parser.ml"
             in
            _menhir_goto_parse_vernac _menhir_env _menhir_stack _v) : 'freshtv172)) : 'freshtv174)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv175) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv176)) : 'freshtv178)) : 'freshtv180)
    | _ ->
        _menhir_fail ()

and _menhir_reduce6 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_parse_seq_ = 
# 114 "/usr/local/share/menhir/standard.mly"
    ( [] )
# 742 "parser.ml"
     in
    _menhir_goto_list_parse_seq_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run1 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv145 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv141 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 8 "parser.mly"
       (string)
# 760 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv139 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 768 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDVERNAC ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv135 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 777 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv133 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 784 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_parse_term = 
# 75 "parser.mly"
  (`Vernac _2)
# 790 "parser.ml"
             in
            _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv134)) : 'freshtv136)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv137 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 800 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv138)) : 'freshtv140)) : 'freshtv142)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv143 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv144)) : 'freshtv146)

and _menhir_run4 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv131 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        _menhir_run5 _menhir_env (Obj.magic _menhir_stack) MenhirState4 _v
    | ENDVERBATIM ->
        _menhir_reduce2 _menhir_env (Obj.magic _menhir_stack) MenhirState4
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState4) : 'freshtv132)

and _menhir_run9 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv129 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv125 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 8 "parser.mly"
       (string)
# 843 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv123 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 851 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDPP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv119 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 860 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv117 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 867 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_parse_term = 
# 77 "parser.mly"
  (`Pretty_print _2)
# 873 "parser.ml"
             in
            _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv118)) : 'freshtv120)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv121 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 883 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv122)) : 'freshtv124)) : 'freshtv126)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv127 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv128)) : 'freshtv130)

and _menhir_run12 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 7 "parser.mly"
       (int*string)
# 898 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv115) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (_1 : (
# 7 "parser.mly"
       (int*string)
# 908 "parser.ml"
    )) = _v in
    ((let _v : 'tv_parse_term = 
# 81 "parser.mly"
  (`Section _1)
# 913 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv116)

and _menhir_run13 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 8 "parser.mly"
       (string)
# 920 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv113) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (tok : (
# 8 "parser.mly"
       (string)
# 930 "parser.ml"
    )) = _v in
    ((let _v : 'tv_parse_term = 
# 98 "parser.mly"
( `Rm_printing tok )
# 935 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv114)

and _menhir_run14 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 10 "parser.mly"
       (string*string)
# 942 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv111) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (query : (
# 10 "parser.mly"
       (string*string)
# 952 "parser.ml"
    )) = _v in
    ((let _v : 'tv_parse_term = 
# 87 "parser.mly"
  (let (name,arglist) = query in `Query (name,(Str.split (Str.regexp ",")
  arglist)))
# 958 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv112)

and _menhir_run15 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 6 "parser.mly"
       (int)
# 965 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv109 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 974 "parser.ml"
    )) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ITEM ->
        _menhir_run16 _menhir_env (Obj.magic _menhir_stack) MenhirState15
    | ENDLST ->
        _menhir_reduce4 _menhir_env (Obj.magic _menhir_stack) MenhirState15
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState15) : 'freshtv110)

and _menhir_run17 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv107 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv103 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 8 "parser.mly"
       (string)
# 1001 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv101 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1009 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | LATEX_MATH ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv97 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1018 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv95 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1025 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_raw_terms = 
# 106 "parser.mly"
  ({Cst.latex = ""; Cst.latex_math=_2; Cst.html=""; Cst.default = ""})
# 1031 "parser.ml"
             in
            _menhir_goto_raw_terms _menhir_env _menhir_stack _menhir_s _v) : 'freshtv96)) : 'freshtv98)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv99 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1041 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv100)) : 'freshtv102)) : 'freshtv104)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv105 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv106)) : 'freshtv108)

and _menhir_run20 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
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
# 8 "parser.mly"
       (string)
# 1067 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv87 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1075 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | LATEX ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv83 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1084 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv81 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1091 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_raw_terms = 
# 104 "parser.mly"
  ({Cst.latex = _2; Cst.latex_math=""; Cst.html=""; Cst.default = ""})
# 1097 "parser.ml"
             in
            _menhir_goto_raw_terms _menhir_env _menhir_stack _menhir_s _v) : 'freshtv82)) : 'freshtv84)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv85 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1107 "parser.ml"
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

and _menhir_run23 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv79 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv75 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 8 "parser.mly"
       (string)
# 1133 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv73 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1141 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | HTML ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv69 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1150 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv67 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1157 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_raw_terms = 
# 108 "parser.mly"
  ({Cst.latex = ""; Cst.latex_math=""; Cst.html=_2; Cst.default = ""})
# 1163 "parser.ml"
             in
            _menhir_goto_raw_terms _menhir_env _menhir_stack _menhir_s _v) : 'freshtv68)) : 'freshtv70)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv71 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1173 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv72)) : 'freshtv74)) : 'freshtv76)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv77 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv78)) : 'freshtv80)

and _menhir_run26 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv65) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    ((let _v : 'tv_parse_term = 
# 83 "parser.mly"
  (`Hrule)
# 1194 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv66)

and _menhir_run27 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv63 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ADD_PRINTING _v ->
        _menhir_run29 _menhir_env (Obj.magic _menhir_stack) MenhirState27 _v
    | CONTENT _v ->
        _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState27 _v
    | HRULE ->
        _menhir_run26 _menhir_env (Obj.magic _menhir_stack) MenhirState27
    | HTML ->
        _menhir_run23 _menhir_env (Obj.magic _menhir_stack) MenhirState27
    | LATEX ->
        _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState27
    | LATEX_MATH ->
        _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState27
    | QUERY _v ->
        _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState27 _v
    | RM_PRINTING _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState27 _v
    | SECTION _v ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState27 _v
    | STARTPP ->
        _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState27
    | STARTVERBATIM ->
        _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState27
    | STARTVERNAC ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState27
    | EMPHASIS ->
        _menhir_reduce8 _menhir_env (Obj.magic _menhir_stack) MenhirState27
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState27) : 'freshtv64)

and _menhir_run28 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 8 "parser.mly"
       (string)
# 1240 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv61) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (_1 : (
# 8 "parser.mly"
       (string)
# 1250 "parser.ml"
    )) = _v in
    ((let _v : 'tv_parse_term = 
# 85 "parser.mly"
  (`Content _1)
# 1255 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv62)

and _menhir_run29 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 9 "parser.mly"
       (bool*string)
# 1262 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv59 * _menhir_state * (
# 9 "parser.mly"
       (bool*string)
# 1271 "parser.ml"
    )) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | HTML ->
        _menhir_run23 _menhir_env (Obj.magic _menhir_stack) MenhirState29
    | LATEX ->
        _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState29
    | LATEX_MATH ->
        _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState29
    | EOF ->
        _menhir_reduce10 _menhir_env (Obj.magic _menhir_stack) MenhirState29
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState29) : 'freshtv60)

and _menhir_errorcase : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    match _menhir_s with
    | MenhirState54 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv33) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv34)
    | MenhirState51 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv35) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv36)
    | MenhirState43 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv37 * _menhir_state * 'tv_parse_lst) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv38)
    | MenhirState40 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv39 * _menhir_state * 'tv_parse_seq) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv40)
    | MenhirState35 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv41 * _menhir_state * 'tv_parse_term) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv42)
    | MenhirState30 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv43 * _menhir_state * 'tv_raw_terms) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv44)
    | MenhirState29 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv45 * _menhir_state * (
# 9 "parser.mly"
       (bool*string)
# 1324 "parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv46)
    | MenhirState27 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv47 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv48)
    | MenhirState16 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv49 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv50)
    | MenhirState15 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv51 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 1343 "parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv52)
    | MenhirState5 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv53 * _menhir_state * (
# 8 "parser.mly"
       (string)
# 1352 "parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv54)
    | MenhirState4 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv55 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv56)
    | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv57) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv58)

and _menhir_reduce2 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_CONTENT_ = 
# 114 "/usr/local/share/menhir/standard.mly"
    ( [] )
# 1371 "parser.ml"
     in
    _menhir_goto_list_CONTENT_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run5 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 8 "parser.mly"
       (string)
# 1378 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv31 * _menhir_state * (
# 8 "parser.mly"
       (string)
# 1387 "parser.ml"
    )) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        _menhir_run5 _menhir_env (Obj.magic _menhir_stack) MenhirState5 _v
    | ENDCOM | ENDVERBATIM ->
        _menhir_reduce2 _menhir_env (Obj.magic _menhir_stack) MenhirState5
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState5) : 'freshtv32)

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

and _menhir_goto_parse_vernac : _menhir_env -> 'ttv_tail -> (
# 14 "parser.mly"
      ((string,string) Cst.cst_node)
# 1415 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _v ->
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv29) = Obj.magic _menhir_stack in
    let (_v : (
# 14 "parser.mly"
      ((string,string) Cst.cst_node)
# 1423 "parser.ml"
    )) = _v in
    ((let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv27) = Obj.magic _menhir_stack in
    let (_1 : (
# 14 "parser.mly"
      ((string,string) Cst.cst_node)
# 1430 "parser.ml"
    )) = _v in
    (Obj.magic _1 : 'freshtv28)) : 'freshtv30)

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

and parse_doc : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (
# 15 "parser.mly"
      (Cst.doc_with_eval)
# 1449 "parser.ml"
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
    | ADD_PRINTING _v ->
        _menhir_run29 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | CONTENT _v ->
        _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | EMPHASIS ->
        _menhir_run27 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | HRULE ->
        _menhir_run26 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | HTML ->
        _menhir_run23 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | LATEX ->
        _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | LATEX_MATH ->
        _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | LST _v ->
        _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | QUERY _v ->
        _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | RM_PRINTING _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | SECTION _v ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | STARTPP ->
        _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | STARTVERBATIM ->
        _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | STARTVERNAC ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | EOF ->
        _menhir_reduce6 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState0) : 'freshtv24)) : 'freshtv26))

and parse_vernac : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (
# 14 "parser.mly"
      ((string,string) Cst.cst_node)
# 1499 "parser.ml"
) =
  fun lexer lexbuf ->
    let _menhir_env = _menhir_init lexer lexbuf in
    Obj.magic (let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv21) = () in
    ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
    let _tok = _menhir_env._menhir_token in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv19) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv3) = Obj.magic _menhir_stack in
        let (_v : (
# 8 "parser.mly"
       (string)
# 1517 "parser.ml"
        )) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv1) = Obj.magic _menhir_stack in
        let (_1 : (
# 8 "parser.mly"
       (string)
# 1524 "parser.ml"
        )) = _v in
        ((let _v : (
# 14 "parser.mly"
      ((string,string) Cst.cst_node)
# 1529 "parser.ml"
        ) = 
# 47 "parser.mly"
  (Cst.Code _1 )
# 1533 "parser.ml"
         in
        _menhir_goto_parse_vernac _menhir_env _menhir_stack _v) : 'freshtv2)) : 'freshtv4)
    | EOF ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv7) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv5) = Obj.magic _menhir_stack in
        ((let _v : (
# 14 "parser.mly"
      ((string,string) Cst.cst_node)
# 1544 "parser.ml"
        ) = 
# 49 "parser.mly"
  (raise Cst.End_of_file)
# 1548 "parser.ml"
         in
        _menhir_goto_parse_vernac _menhir_env _menhir_stack _v) : 'freshtv6)) : 'freshtv8)
    | STARTCOM ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv11) = Obj.magic _menhir_stack in
        ((let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv9) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | CONTENT _v ->
            _menhir_run5 _menhir_env (Obj.magic _menhir_stack) MenhirState54 _v
        | ENDCOM ->
            _menhir_reduce2 _menhir_env (Obj.magic _menhir_stack) MenhirState54
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState54) : 'freshtv10)) : 'freshtv12)
    | STARTDOC ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv15) = Obj.magic _menhir_stack in
        ((let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv13) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | CONTENT _v ->
            _menhir_run5 _menhir_env (Obj.magic _menhir_stack) MenhirState51 _v
        | ENDCOM ->
            _menhir_reduce2 _menhir_env (Obj.magic _menhir_stack) MenhirState51
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState51) : 'freshtv14)) : 'freshtv16)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv17) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv18)) : 'freshtv20)) : 'freshtv22))



