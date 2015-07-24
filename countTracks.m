%runSlaveChannelClassification(data, varargin) identifies trajectories with significant slave channel fluorescence
%
% Input:
%          data : structure returned by loadConditionData()
%
% Options ('specifier', value):
%          'np' : number of points to use for randomized detections
%    'Cutoff_f' : minimum track length to consider for classification (in frames)
%
% Notes: This function modifies the output of runTrackProcessing(), 
%        by default saved in Tracking/ProcessedTracks.mat

% Francois Aguet, October 2010 (last modified: 10/09/2012)

function countTracks(data, varargin)

ip = inputParser;
ip.CaseSensitive = false;
ip.addParamValue('ChannelNames', []);
ip.parse(varargin{:});

filename = 'ProcessedTracks.mat';

% load tracks (all)
ts = load([data.source 'Tracking' filesep filename]);
tracks = [ts.tracks];
catFilter = find([ts.tracks.catIdx] == 1 | [ts.tracks.catIdx] == 5);

total = numel(tracks(catFilter));
significantMasters = [ts.tracks.significantMaster];
significantSlaves = [ts.tracks.significantSlave];

significantMasters = significantMasters(:,catFilter);
significantSlaves = significantSlaves(:,catFilter);

outputStr = 'Total tracks detected: %d\n';

sprintf('The price of %s on %d/%d/%d was $%.2f.', ...
        'bread', 7, 1, 2006, 2.49)
    
%load cellmask
maskPath = [data.source 'Detection' filesep 'cellmask.tif'];
mask = double(imread(maskPath));
maskLog = mask == 1;
mSize = sqrt(numel(mask(maskLog)));
mSizeStr = sprintf('Total number of pixels^2 is %d\n', ... 
    mSize);

for i=2:numel(data.channels)
    counts(i) = numel(find(significantMasters(i,:,:) == 1));
    if isempty(ip.Results.ChannelNames)
       outputStr = [outputStr 'Significant tracks in channel ' i ': %d\n'];
    else
       outputStr = [outputStr ip.Results.ChannelNames{i} '-positive tracks: %d\n'];
    end
end

fprintf(mSizeStr, outputStr, [total counts(2:end)]);