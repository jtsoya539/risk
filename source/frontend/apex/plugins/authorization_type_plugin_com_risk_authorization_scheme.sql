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
--     PLUGIN: 115500696919685442
--   Manifest End
--   Version:         20.2.0.00.20
--   Instance ID:     500134684140051
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/authorization_type/com_risk_authorization_scheme
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(115500696919685442)
,p_plugin_type=>'AUTHORIZATION TYPE'
,p_name=>'COM.RISK.AUTHORIZATION_SCHEME'
,p_display_name=>'RISK Authorization Scheme'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'FUNCTION is_authorized(p_authorization IN apex_plugin.t_authorization,',
'                       p_plugin        IN apex_plugin.t_plugin)',
'  RETURN apex_plugin.t_authorization_exec_result IS',
'  l_result     apex_plugin.t_authorization_exec_result;',
'  l_id_permiso t_permisos.id_permiso%TYPE;',
'BEGIN',
'  l_id_permiso           := ''PAGE:'' || upper(:app_alias) || '':'' ||',
'                            upper(:app_page_alias);',
'  l_result.is_authorized := k_autorizacion.f_validar_permiso(k_usuario.f_buscar_id(:app_user),',
'                                                             l_id_permiso);',
'  RETURN l_result;',
'END;'))
,p_api_version=>2
,p_execution_function=>'is_authorized'
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
