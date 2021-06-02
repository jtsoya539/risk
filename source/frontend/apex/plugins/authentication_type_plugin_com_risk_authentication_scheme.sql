prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_200200 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2020.10.01'
,p_release=>'20.2.0.00.20'
,p_default_workspace_id=>2600325421114677
,p_default_application_id=>539
,p_default_id_offset=>0
,p_default_owner=>'RISK'
);
end;
/
 
prompt APPLICATION 539 - RISK ADMIN
--
-- Application Export:
--   Application:     539
--   Name:            RISK ADMIN
--   Date and Time:   21:16 Tuesday June 1, 2021
--   Exported By:     JMEZA
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 115400822496682583
--   Manifest End
--   Version:         20.2.0.00.20
--   Instance ID:     500134684140051
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/authentication_type/com_risk_authentication_scheme
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(115400822496682583)
,p_plugin_type=>'AUTHENTICATION TYPE'
,p_name=>'COM.RISK.AUTHENTICATION_SCHEME'
,p_display_name=>'RISK Authentication Scheme'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'FUNCTION authentication_sentry(p_authentication IN apex_plugin.t_authentication,',
'                               p_plugin         IN apex_plugin.t_plugin,',
'                               p_is_public_page IN BOOLEAN)',
'  RETURN apex_plugin.t_authentication_sentry_result IS',
'  l_result apex_plugin.t_authentication_sentry_result;',
'BEGIN',
'  l_result.is_valid := k_sesion.f_validar_sesion(to_char(p_authentication.session_id));',
'',
'  RETURN l_result;',
'END;',
'',
'FUNCTION authentication_inval(p_authentication IN apex_plugin.t_authentication,',
'                              p_plugin         IN apex_plugin.t_plugin)',
'  RETURN apex_plugin.t_authentication_inval_result IS',
'  l_result apex_plugin.t_authentication_inval_result;',
'BEGIN',
unistr('  k_sesion.p_cambiar_estado(to_char(p_authentication.session_id), ''I''); -- INV\00C1LIDO'),
'',
'  l_result.redirect_url := p_authentication.invalid_session_url;',
'',
'  RETURN l_result;',
'END;',
'',
'FUNCTION authentication_auth(p_authentication IN apex_plugin.t_authentication,',
'                             p_plugin         IN apex_plugin.t_plugin,',
'                             p_password       IN VARCHAR2)',
'  RETURN apex_plugin.t_authentication_auth_result IS',
'  l_result    apex_plugin.t_authentication_auth_result;',
'  l_id_sesion t_sesiones.id_sesion%TYPE;',
'BEGIN',
'  l_result.is_authenticated := k_autenticacion.f_validar_credenciales(p_authentication.username,',
'                                                                      p_password,',
'                                                                      k_autenticacion.c_clave_acceso);',
'',
'  IF l_result.is_authenticated THEN',
'    l_id_sesion := k_autenticacion.f_iniciar_sesion(k_aplicacion.f_id_aplicacion(apex_app_setting.get_value(''RISK_APP_KEY'')),',
'                                                    p_authentication.username,',
'                                                    to_char(p_authentication.session_id),',
'                                                    NULL);',
'  ELSE',
unistr('    l_result.display_text := ''Credenciales inv\00E1lidas'';'),
'  END IF;',
'',
'  RETURN l_result;',
'END;',
'',
'FUNCTION authentication_logout(p_authentication IN apex_plugin.t_authentication,',
'                               p_plugin         IN apex_plugin.t_plugin)',
'  RETURN apex_plugin.t_authentication_logout_result IS',
'  l_result apex_plugin.t_authentication_logout_result;',
'BEGIN',
'  k_sesion.p_cambiar_estado(to_char(p_authentication.session_id), ''F''); -- FINALIZADO',
'',
'  l_result.redirect_url := p_authentication.logout_url;',
'',
'  RETURN l_result;',
'END;',
'',
'FUNCTION authentication_ajax(p_authentication IN apex_plugin.t_authentication,',
'                             p_plugin         IN apex_plugin.t_plugin)',
'  RETURN apex_plugin.t_authentication_ajax_result IS',
'  l_result apex_plugin.t_authentication_ajax_result;',
'BEGIN',
'',
'  RETURN l_result;',
'END;'))
,p_api_version=>2
,p_ajax_function=>'authentication_ajax'
,p_session_sentry_function=>'authentication_sentry'
,p_invalid_session_function=>'authentication_inval'
,p_authentication_function=>'authentication_auth'
,p_post_logout_function=>'authentication_logout'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'v0.1.0'
,p_about_url=>'https://jtsoya539.github.io/risk/'
);
end;
/
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
