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
run("Make Substack...", "channels=1-2 frames=2,3,8,18,33,63,93");
Stack.setChannel(1);
Stack.setFrame(1);
setMetadata("Label", "-1 min");
Stack.setFrame(2);
setMetadata("Label", "0 min");
Stack.setFrame(3);
setMetadata("Label", "5 min");
Stack.setFrame(4);
setMetadata("Label", "15 min");
Stack.setFrame(5);
setMetadata("Label", "30 min");
Stack.setFrame(6);
setMetadata("Label", "60 min");
Stack.setFrame(7);
setMetadata("Label", "90 min");

Stack.setChannel(2);
Stack.setFrame(1);
setMetadata("Label", "-1 min");
Stack.setFrame(2);
setMetadata("Label", "0 min");
Stack.setFrame(3);
setMetadata("Label", "5 min");
Stack.setFrame(4);
setMetadata("Label", "15 min");
Stack.setFrame(5);
setMetadata("Label", "30 min");
Stack.setFrame(6);
setMetadata("Label", "60 min");
Stack.setFrame(7);
setMetadata("Label", "90 min");

saveAs("Tiff", directory+batchlist[imgi]+"-dt.tif");
run("Close All");
};
setBatchMode(false);