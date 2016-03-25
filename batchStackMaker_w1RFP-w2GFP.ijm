dirp=getDirectory("Choose a Directory");
folderlist=getFileList(dirp);
//Array.print(folderlist);
setBatchMode(true);
for (i=0;i<folderlist.length;i++){
	if (File.isDirectory(dirp+folderlist[i])==1 && folderlist[i]!="nd/" ){
		run("Image Sequence...", "open=["+dirp+folderlist[i]+"] sort");
		img=getTitle();
		n=nSlices;
		ng=n/2;nr=n/2;

		selectWindow(img);
		run("Make Substack...", "  slices=1-"+ng);
		rename("RFP");

		selectWindow(img);
		run("Make Substack...", "  slices="+ng+1+"-"+n);
		rename("GFP");

		selectWindow(img);
		close();

		run("Merge Channels...", "c1=RFP c2=GFP create");
		run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");
		rename("img");

		saveAs("Tiff", dirp+img+".tif");
		run("Close All");
		
	}
}
setBatchMode(false);
//img=getTitle();
//dir=getDirectory("image");
//run("Image Sequence...", "open=["+dir+img+"] sort");