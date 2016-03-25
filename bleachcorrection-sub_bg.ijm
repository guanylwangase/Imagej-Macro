directory=getDirectory("Choose a Directory");
list=getFileList(directory);
batchlist=newArray();
for (i=0;i<list.length;i++){
	if(endsWith(list[i], '.tif')==1 || endsWith(list[i], '.tiff')==1){
	batchlist=Array.concat(batchlist,list[i]);}
}

setBatchMode(true);
for(imgi=0;imgi<batchlist.length;imgi++){
run("Close All");
open(directory+batchlist[imgi]);
run("Subtract Background...", "rolling=50");
//run("Bleach Correction", "correction=[Simple Ratio] background=0");
saveAs("Tiff", directory+batchlist[imgi]+"_SB.tif");
run("Close All");
};
setBatchMode(false);