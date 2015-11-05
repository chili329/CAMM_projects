%select multiple files
all_file = uipickfiles;
file_num = size(all_file,2);

total_int = 0;
for i = 1:file_num
    ref_file = all_file{i};
    [ref_int, G, S, ref_ph1, ref_md1] = ref_read(ref_file);
    total_int = total_int+ref_int(:);
end

hist(total_int,20);

% Get histogram patches
ph = get(gca,'children');
% Determine number of histogram patches
N_patches = length(ph);
for i = 1:N_patches
      % Get patch vertices
      vn = get(ph(i),'Vertices');
      % Adjust y location
      vn(:,2) = vn(:,2) + 1;
      % Reset data
      set(ph(i),'Vertices',vn)

      %change face color
      set(ph(i),'FaceColor',[0 0 0])
end


% Change scale
set(gca,'yscale','log')
set(gca,'fontsize',20)