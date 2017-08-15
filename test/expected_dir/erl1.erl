erlang	comment	%%%----------------------------------------------------------------------
erlang	comment	%%% File    : erl1.erl
erlang	comment	%%% Author  : Jason Allen <jason@ohloh.net> - kinda - just repurposing random code
erlang	comment	%%% Purpose : Test out the erlang parsing
erlang	comment	%%% Created : 1/17/2007 by Jason Allen <jason@ohloh.net>
erlang	comment	%%% Id      : $Id: erl1.erl 1 2007-17-01 jason $
erlang	comment	%%%----------------------------------------------------------------------
erlang	blank	
erlang	code	-module(erl1).
erlang	code	-author('jason@ohloh.net').
erlang	code	-vsn('$Revision: 1 $ ').
erlang	blank	
erlang	comment	%% External exports
erlang	code	-export([import_file/1,
erlang	code		 import_dir/1]).
erlang	blank	
erlang	code	-include("random.hrl").
erlang	code	-include("more_random.hrl").
erlang	blank	
erlang	comment	%%%----------------------------------------------------------------------
erlang	comment	%%% API
erlang	comment	%%%----------------------------------------------------------------------
erlang	blank	
erlang	code	import_file(File) ->
erlang	code	    User = filename:rootname(filename:basename(File)),
erlang	code	    Server = filename:basename(filename:dirname(File)),
erlang	code	    case (jlib:nodeprep(User) /= error) andalso
erlang	code		(jlib:nameprep(Server) /= error) of
erlang	code		true ->
erlang	code		    case file:read_file(File) of
erlang	code			{ok, Text} ->
erlang	code			    case xml_stream:parse_element(Text) of
erlang	code				El when element(1, El) == xmlelement ->
erlang	code				    case catch process_xdb(User, Server, El) of
erlang	code					{'EXIT', Reason} ->
erlang	code					    ?ERROR_MSG(
erlang	code					       "Error while processing file \"~s\": ~p~n",
erlang	code					       [File, Reason]),
erlang	code					       {error, Reason};
erlang	code					_ ->
erlang	code					    ok
erlang	code				    end;
erlang	code				{error, Reason} ->
erlang	code				    ?ERROR_MSG("Can't parse file \"~s\": ~p~n",
erlang	code					       [File, Reason]),
erlang	code				    {error, Reason}
erlang	code			    end;
erlang	code			{error, Reason} ->
erlang	code			    ?ERROR_MSG("Can't read file \"~s\": ~p~n", [File, Reason]),
erlang	code			    {error, Reason}
erlang	code		    end;
erlang	code		false ->
erlang	code		    ?ERROR_MSG("Illegal user/server name in file \"~s\"~n", [File]),
erlang	code		    {error, "illegal user/server"}
erlang	code	    end.
erlang	blank	
erlang	blank	
erlang	code	import_dir(Dir) ->
erlang	code	    {ok, Files} = file:list_dir(Dir),
erlang	code	    MsgFiles = lists:filter(
erlang	code			 fun(FN) ->
erlang	code				 case string:len(FN) > 4 of
erlang	code				     true ->
erlang	code					 string:substr(FN,
erlang	code						       string:len(FN) - 3) == ".xml";
erlang	code				     _ ->
erlang	code					 false
erlang	code				 end
erlang	code			 end, Files),
erlang	code	    lists:foldl(
erlang	code	      fun(FN, A) ->
erlang	code		      Res = import_file(filename:join([Dir, FN])),
erlang	code		      case {A, Res} of
erlang	code			  {ok, ok} -> ok;
erlang	code			  {ok, _} -> {error, "see aoabberd log for details"};
erlang	code			  _ -> A
erlang	code		      end
erlang	code	      end, ok, MsgFiles).
erlang	blank	
erlang	comment	%%%----------------------------------------------------------------------
erlang	comment	%%% Internal functions
erlang	comment	%%%----------------------------------------------------------------------
erlang	blank	
erlang	code	process_xdb(User, Server, {xmlelement, Name, _Attrs, Els}) ->
erlang	code	    case Name of
erlang	code		"xdb" ->
erlang	code		    lists:foreach(
erlang	code		      fun(El) ->
erlang	code			      xdb_data(User, Server, El)
erlang	code		      end, Els);
erlang	code		_ ->
erlang	code		    ok
erlang	code	    end.
erlang	blank	
erlang	blank	
erlang	code	xdb_data(User, Server, {xmlcdata, _CData}) ->
erlang	code	    ok;
erlang	code	xdb_data(User, Server, {xmlelement, _Name, Attrs, _Els} = El) ->
erlang	code	    From = jlib:make_jid(User, Server, ""),
erlang	code	    LServer = jlib:nameprep(Server),
erlang	code	    case xml:get_attr_s("xmlns", Attrs) of
erlang	code		?NS_AUTH ->
erlang	code		    Password = xml:get_tag_cdata(El),
erlang	code		    ejabberd_auth:set_password(User, Server, Password),
erlang	code		    ok;
erlang	code		?NS_ROSTER ->
erlang	code		    case lists:member(mod_roster_odbc,
erlang	code				      gen_mod:loaded_modules(LServer)) of
erlang	code			true ->
erlang	code			    catch mod_roster_odbc:set_items(User, Server, El);
erlang	code			false ->
erlang	code			    catch mod_roster:set_items(User, Server, El)
erlang	code		    end,
erlang	code		    ok;
erlang	code		?NS_LAST ->
erlang	code		    TimeStamp = xml:get_attr_s("last", Attrs),
erlang	code		    Status = xml:get_tag_cdata(El),
erlang	code		    case lists:member(mod_last_odbc,
erlang	code				      gen_mod:loaded_modules(LServer)) of
erlang	code			true ->
erlang	code			    catch mod_last_odbc:store_last_info(
erlang	code				    User,
erlang	code				    Server,
erlang	code				    list_to_integer(TimeStamp),
erlang	code				    Status);
erlang	code			false ->
erlang	code			    catch mod_last:store_last_info(
erlang	code				    User,
erlang	code				    Server,
erlang	code				    list_to_integer(TimeStamp),
erlang	code				    Status)
erlang	code		    end,
erlang	code		    ok;
erlang	code		?NS_VCARD ->
erlang	code		    case lists:member(mod_vcard_odbc,
erlang	code				      gen_mod:loaded_modules(LServer)) of
erlang	code			true ->
erlang	code			    catch mod_vcard_odbc:process_sm_iq(
erlang	code				    From,
erlang	code				    jlib:make_jid("", Server, ""),
erlang	code				    #iq{type = set, xmlns = ?NS_VCARD, sub_el = El});
erlang	code			false ->
erlang	code			    catch mod_vcard:process_sm_iq(
erlang	code				    From,
erlang	code				    jlib:make_jid("", Server, ""),
erlang	code				    #iq{type = set, xmlns = ?NS_VCARD, sub_el = El})
erlang	code		    end,
erlang	code		    ok;
erlang	code		"jabber:x:offline" ->
erlang	code		    process_offline(Server, From, El),
erlang	code		    ok;
erlang	code		XMLNS ->
erlang	code		    case xml:get_attr_s("j_private_flag", Attrs) of
erlang	code			"1" ->
erlang	code			    catch mod_private:process_sm_iq(
erlang	code				    From,
erlang	code				    jlib:make_jid("", Server, ""),
erlang	code				    #iq{type = set, xmlns = ?NS_PRIVATE,
erlang	code					sub_el = {xmlelement, "query", [],
erlang	code						  [jlib:remove_attr(
erlang	code						     "j_private_flag",
erlang	code						     jlib:remove_attr("xdbns", El))]}});
erlang	code			_ ->
erlang	code			    ?DEBUG("jd2ejd: Unknown namespace \"~s\"~n", [XMLNS])
erlang	code		    end,
erlang	code		    ok
erlang	code	    end.
erlang	blank	
erlang	blank	
erlang	code	process_offline(Server, To, {xmlelement, _, _, Els}) ->
erlang	code	    LServer = jlib:nameprep(Server),
erlang	code	    lists:foreach(fun({xmlelement, _, Attrs, _} = El) ->
erlang	code				  FromS = xml:get_attr_s("from", Attrs),
erlang	code				  From = case FromS of
erlang	code					     "" ->
erlang	code						 jlib:make_jid("", Server, "");
erlang	code					     _ ->
erlang	code						 jlib:string_to_jid(FromS)
erlang	code					 end,
erlang	code				  case From of
erlang	code				      error ->
erlang	code					  ok;
erlang	code				      _ ->
erlang	code					  ejabberd_hooks:run(offline_message_hook,
erlang	code							     LServer,
erlang	code							     [From, To, El])
erlang	code				  end
erlang	code			  end, Els).
erlang	blank	
