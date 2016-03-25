path=getDirectory("Choose a Directory");

filelist=newArray();
filelist=getFileList(path);

logname="log.txt";

getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
MonthNames = newArray("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
if (File.exists(path+logname)==0){
	f = File.open(path+logname);
	print(f, toString(year) + MonthNames[month] + toString(dayOfMonth) + "\t"  + toString(hour) + "H" + toString(minute) + "M" + toString(second) + "S" + "\r");
	File.append("Image Name" + "\t" + "Growth Stage" + "\t" + "Neurite Number" + "\t"  + "Neurite Length" + "\t"+ "Growth Stage" + "\t" + "Longest Neurite" , path+logname);
}
else{
	File.append(toString(year) + MonthNames[month] + toString(dayOfMonth) + "\t"  + toString(hour) + "\t" + toString(hour) + "H" + toString(minute) + "M" + toString(second) + "S" + "\r", path+logname);
	File.append("Image Name" + "\t" + "Growth Stage" + "\t" + "Neurite Number" + "\t"  + "Neurite Length" + "\t"+ "Growth Stage" + "\t" + "Longest Neurite" , path+logname);
}


for (i=0;i<filelist.length;i++){
	open(path + filelist[i]);
	title=getTitle();
	run("Colors...", "foreground=white background=black selection=yellow");


////////////////////Classification////////////////////////
waitForUser;
run("Select None");
run("Save");

  Dialog.create("Classification image n"+i+" of "+filelist.length);
  items = newArray("1", "2", "3","0");
  Dialog.addRadioButtonGroup("Stage", items, 1, 4, "3");
  Dialog.addCheckbox("Run Analysis", true);

  Dialog.show;
  stage=Dialog.getRadioButton();
  analysis = Dialog.getCheckbox();


//load default parameters

if (i==0){
  mwidth = 20;
  marea = 500;
  mlength = 75;
  rmax = 2;
  rmin = 1;
  rgauss = 2;}

if (analysis==true){
	
  Dialog.create("Axon Outgrowth Analysis");
  Dialog.addNumber("Maximum Neurite Width(pixel):", mwidth);
  Dialog.addNumber("Remove Partical Smaller Than(pixel^2):", marea);
  Dialog.addNumber("Minimum Neurite Length(pixel):", mlength);

  Dialog.addNumber("Radius of Maximum Filter :", rmax);
  Dialog.addNumber("Radius of Miximum Filter Radius:", rmin);
  Dialog.addNumber("Radius of Gaussian Blur:", rgauss);

  Dialog.show;
  
  mwidth = Dialog.getNumber();
  marea = Dialog.getNumber();
  mlength = Dialog.getNumber();
  rmax = Dialog.getNumber();
  rmin = Dialog.getNumber();
  rgauss = Dialog.getNumber();
	
	selectWindow(title);
	run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
	AnalyseNeurite(title, stage, path, logname);}	//end of analysis
	
	run("Close All");
}




function AnalyseNeurite(img, stage, outputpath, logename){

run("Maximum...", "radius="+rmax);
run("Minimum...", "radius="+rmin);
run("Gaussian Blur...", "sigma="+rgauss);

run("Threshold...");
setOption("BlackBackground", true);
waitForUser;
run("Convert to Mask");
selectWindow("Threshold");
run("Close");

run("Maximum...", "radius="+rmax);
run("Subtract Background...", "rolling="+mwidth+" sliding disable");
run("Minimum...", "radius="+rmin);


setAutoThreshold("Default dark");
setThreshold(128, 255);
run("Convert to Mask");

////////////////////////////////remove small particle//////////////
run("Select None");
run("Analyze Particles...", "size=0-Infinity circularity=0.00-1.00 show=Nothing display clear add");
roiManager("Show None");

n=roiManager("count");
for (i=n-1;i>=0;i+=-1){
	a=getResult("Area", i);
	if (a<500){
		roiManager("select", i);
		run("Clear", "slice");
		roiManager("delete");
	}
}

////////////////////////////////Create skeleton/////////////////
run("Skeletonize (2D/3D)");
saveAs("Tiff", outputpath+img+"_skeleton.tif");

run("Analyze Skeleton (2D/3D)", "prune=none");

lest=0;
for (i=0;i<nResults;i++){
	l=getResult("Maximum Branch Length",i-1);
	if (l>mlength){
	File.append(img + "\t" + stage + "\t" +toString(i+1) + "\t" + l, outputpath+logename);
	if(l>=lest){lest=l;}	
	}

}
File.append("\t" + "\t" + "\t" + "\t" + stage  + "\t" + lest, outputpath+logename);

}////////////////end of function/////////////////