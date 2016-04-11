FILE_NAMING_RULE: %(entity_name)_%(arch_name)_config.vhd
DESCRIPTION_START
This is the default template used for the creation of VHDL Configuration files.
Template supplied by UCM-ABSYS.
DESCRIPTION_END
--------------------------------------------------------------------------------
-- Company       : UCM-ABSYS
-- Engineer      : %(user) (%(host))
-- Create Date   : %(time) %(date)
-- Library Name  : %(library)
-- Module Name   : %(entity_name).%(arch_name)
-- Project Name  : %(project_name)
-- Target Devices: Virtex-6
-- Language      : VHDL
-- Tool versions : Entry = HDL Designer %(version)
--                 Simulator = Questa 10.1d             
--                 Synthesis = XST 14.1
-- Description   : 
-- Dependencies  :
-- Revision      : 
-- Additional Comments: 
--     
--------------------------------------------------------------------------------
-- Revision list
-- Version    Author    Date           Changes
--    1.0       CAD     %(date)      New version
-- ----------------------------------------------------------------------------
--==============================================================================
configuration %(entity_name)_config of %(entity_name) is
   for %(arch_name)
   end for;
end %(entity_name)_config;
--==============================================================================