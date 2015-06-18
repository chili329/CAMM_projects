%plot([1 2],[mean(newFA) mean(newnonFA)],'bo')

%errorbar([1 2],[mean(newFA) mean(newnonFA)],[std(newFA) std(newnonFA)],'ks','MarkerFaceColor','k')
%axis([0 3 2 2.5])


%get rid of background part
FA(256-19:256,:) = [];
FA(118:138,:) = [];
FA(1:20,:) = [];
nonFA(256-19:256,:) = [];
nonFA(118:138,:) = [];
nonFA(1:20,:) = [];
newFA = reshape(FA,195*2,1);
newnonFA = reshape(nonFA,195*2,1);

barwitherr([std(newFA) std(newnonFA)],[mean(newFA) mean(newnonFA)],'r')
axis([0 3 1.8 2.5])