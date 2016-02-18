pro select, arch_dir=arch_dir, sim1=sim1, sim2=sim2, simdir, help=help
;
; - - Procedure written to select the simulation for use, via selection as defined within premain.pro
; - - variables
; 
; Author: Benjamin MacFarlane
; Date: 17/10/2014
; Contact: bmacfarlane@uclan.ac.uk
;
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
if (keyword_set(help) eq 1) then begin
   Message, 'Usage:',/info
   Message, 'select, arch_dir, sim1, sim2, help=help', /info
   Message, 'Purpose: Read simulation required by user, and find ', /info
   Message, '         file to which SynCMD runs over', /info
   Message, 'Input:   arch_dir = Directory source for SynCMD', /info
   Message, '	      sim1 = Simulation to be used (MUGS or MaGICC)', /info
   Message, '	      sim2 = Simulation iteration to be used (g1536 or g15784)', /info
   Message, 'Outputs: simdir = Directory file that the data is read from', /info
   return
endif
;
;
; - - - VARIABLE DEFINITIONS - - - ;
;
;
; - - -	MAIN PROGRAM - - - ;
;
;
if (sim1 eq 'MUGS') AND (sim2 eq 'g1536') AND (sim1 ne 'MaGICC') AND (sim2 ne 'g15784') then simdir=arch_dir+'Simulations/MUGS-g1536-01024/g1536.01024'
;
if (sim1 eq 'MUGS') AND (sim2 eq 'g15784') AND (sim1 ne 'MaGICC') AND (sim2 ne 'g1536')  then simdir=arch_dir+'Simulations/MUGS-g15784-1024/g15784.01024.groupone'
;
if (sim1 eq 'MaGICC') AND (sim2 eq 'g1536') AND (sim1 ne 'MUGS') AND (sim2 ne 'g15784')  then simdir=arch_dir+'Simulations/MaGICC-g1536-1024/g1536.01024'
;
if (sim1 eq 'MaGICC') AND (sim2 eq 'g15784') AND (sim1 ne 'MUGS') AND (sim2 ne 'g1536')  then simdir=arch_dir+'Simulations/MaGICC-g15784-1024/g15784.01024'
;
if (sim1 eq 'Selene') AND (sim1 ne 'MaGICC') AND (sim1 ne 'MUGS') then simdir=arch_dir+'Simulations/Selene/reduced_data_selene-ch-10.txt'
;
return
end
