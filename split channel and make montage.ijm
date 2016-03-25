directory=getDirectory("Choose Save Directory");
list=getList("image.titles");

newImage("Montage", "RGB black", 512, 512, 1);

if (list.length==0){
   print("No image windows are open");
   selectWindow("Montage");
   close();}
else {
		
   for (i=0; i<list.length; i++){
   	selectWindow(list[i]);
   	run("Save");
   	
   	run("RGB Color");
   	run("Copy");
   	close();

	selectWindow(list[i]);
   	saveAs("Jpeg", directory+list[i]+".jpg");
   	run("Split Channels");
   	
   	selectWindow("Montage");
   	if (nSlices==1)
   		{run("Paste");}
   	else {
   		run("Add Slice");
   		run("Paste");
   		}
   	
   	

///channel 1
   	selectWindow("C1-"+list[i]);
   	saveAs("Jpeg", directory+list[i]+"_C1.jpg");
   	run("Copy");
   	close();
   	
   	selectWindow("Montage");
   	run("Add Slice");
   	run("Paste");

   	
   	
////channel 2
   	selectWindow("C2-"+list[i]);
   	saveAs("Jpeg", directory+list[i]+"_C2.jpg");
   	run("Copy");
   	close();
   	
   	selectWindow("Montage");
   	run("Add Slice");
   	run("Paste");
  	
   }
	selectWindow("Montage");
   	run("Make Montage...", "columns=3 rows="+list.length+" scale=1 first=1 last="+nSlices+" increment=1 border=0 font=12");
   	saveAs("Jpeg", directory+"Montage.jpg");
}