All algoriths were performed in MATLAB. 
Statistics and FastICA packages must be installed.

The data for the handwritten number identification problem is not included in this folder due to its large file size.
They should be downloaded from: http://yann.lecun.com/exdb/mnist/
There are 4 files to download from the site.
Please download these files and copy them into the number_id subfolder.

To execute:
The subfolder for the handwritten number identification problem data and code: number_id
The subfolder for the cancer diagnosis problem data and code: diagnosis
Each subfolder contains separate files for each of the different algorithms.

PCA: makePCA	
ICA: ImakeICA
randomized projection: makeRP
k-means: makeClusters
EM: makeEM

Use the file readData.m to read the data.
The number_id folder also contains neural network algorithms: compNN.m, compNN2.m, nn.m, nn2.m, nn3.m, nn4.m, nn6.m, and nn7.m

The neural network (nn) files train the neural network for different data types (k-means, EM, PCA, ICA, RP, naive, and original data). The last command in the file indicates which set will be trained.
When these programs are exectuted, output data is saved, plots are generated, and image files created.
The nn programs are the only ones that need user input. For example, for a 2 layer neural network with 20 nodes each, the input would be ( [ 50 50 10 ] ). The last number must be 10 for the algorithm to work.
compNN.m and compNN2.m output compiled graphs for the neural network.


