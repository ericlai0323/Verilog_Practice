% 讀取 CSI.txt 文件
fileID = fopen('CSI.txt', 'r');
data = fscanf(fileID, '%e');
fclose(fileID);

data = data * 2^10;

Output = max(data);
FixOutput = fix(Output);