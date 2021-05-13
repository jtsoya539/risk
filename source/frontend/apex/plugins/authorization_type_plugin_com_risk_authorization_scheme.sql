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
,p_default_application_id=>103
,p_default_id_offset=>45504172824265021
,p_default_owner=>'RISK'
);
end;
/
 
prompt APPLICATION 103 - CRED Admin
--
-- Application Export:
--   Application:     103
--   Name:            CRED Admin
--   Date and Time:   20:50 Sunday April 18, 2021
--   Exported By:     JMEZA
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 46700253715169597
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
 p_id=>wwv_flow_api.id(46700253715169597)
,p_plugin_type=>'AUTHORIZATION TYPE'
,p_name=>'COM.RISK.AUTHORIZATION_SCHEME'
,p_display_name=>'RISK Authorization Scheme'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_api_version=>2
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
