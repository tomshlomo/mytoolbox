function [s, fs] = read_anechoic_recordings(n, len, outputType)

if nargin==0
    n = -1;
end
if n<0
    n = 49:48-n;
end
if nargin<2
    len = inf;
end
if nargin<3
    if length(n) == 1
        outputType = 'array';
    else
        outputType = 'cell';
    end
end
s = cell(length(n),1);
fs = zeros(length(n),1);
folder = mfilename('fullpath');
folder = folder(1: find(folder=='/',1,'last'));
path = [folder 'AnechoicRecordings/%02d.flac'];
for i=1:length(n)
    [s{i}, fs(i)] = audioread(sprintf(path, n(i)));
    i1 = find(s{i}, 1);
    s{i} = s{i}(i1:end, 1);
    s{i} = s{i}(1:min(end, round(len*fs(i))));
end

switch lower(outputType)
    case {'a','array'}
        if length(s)==1
            s = s{1};
        else
            assert(all(fs(1)==fs));
            m = max(cellfun(@length, s));
            sb = s;
            s = zeros(m, length(sb));
            for i=1:length(sb)
                s(1:length(sb{i}), i)  = sb{i};
            end
            fs = fs(1);
        end
    case {'c','cell'}
        
    otherwise
        error('unkwnon option')
end

end