%test Bio-Formats

%open image file
data = bfopen;

%accessing planes, first z then t
% seriesCount = size(data, 1)
% series = data{1,1};
% planeCount = size(series,1)

%show all planes
% for i = 1:planeCount
%     series_plane = series{i, 1};
%     imagesc(series_plane);
%     %pause(0.4)
% end

%output key lsm meta data
%metadata info
metadata = data{1, 2};
metadataKeys = metadata.keySet().iterator();

%get all metadata
for i=1:metadata.size()
  key = metadataKeys.nextElement();
  value = metadata.get(key);
  fprintf('%s = %s\n', key, value)
end

%display metadata of interest
list1 = {'Laser Name #1';'Laser Name #2'};
list510 = {'Recording Objective #1';'IlluminationChannel Wavelength #1';'DetectionChannel Filter Name #1';...
    };

% for i = 1:size(list1)
%     key = list1{i};
%     value = metadata.get(list1{i});
%     fprintf('%s = %s\n', key, value)
% end