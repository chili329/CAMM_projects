%fit the segment of image stack scan with binding model

function [Nt,tauT,sigT] = iMSD_seg_bind(scan)
%[bg,Nt,tauT,sigT]
%directly take the entire stack for the fitting

%for all time point fitting
[xnew, residual] = bind_fit_stack(scan);
Nt = xnew(2);
tauT = xnew(3);
sigT = xnew(4);


