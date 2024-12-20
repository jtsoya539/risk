prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.1'
,p_default_workspace_id=>16127146599720668
,p_default_application_id=>539
,p_default_id_offset=>16129305178841323
,p_default_owner=>'RISK'
);
end;
/
 
prompt APPLICATION 539 - RISK ADMIN
--
-- Application Export:
--   Application:     539
--   Name:            RISK ADMIN
--   Date and Time:   16:07 Sunday September 8, 2024
--   Exported By:     RISK
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 131630002098526765
--   Manifest End
--   Version:         24.1.1
--   Instance ID:     9655952054092436
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/authorization_type/com_risk_authorization_scheme
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(131630002098526765)
,p_plugin_type=>'AUTHORIZATION TYPE'
,p_name=>'COM.RISK.AUTHORIZATION_SCHEME'
,p_display_name=>'RISK Authorization Scheme'
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
,p_version_scn=>39539363226869
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'v0.1.0'
,p_about_url=>'https://jtsoya539.github.io/risk/'
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
