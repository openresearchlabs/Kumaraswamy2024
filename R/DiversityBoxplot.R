#################################
# Diversity index caulcaltion and plotting of the results

#################################
## Get packages!
svDialogsT <- require(svDialogs)
if(!svDialogsT) {cat("Please install package \'svDialogs\' before running this script!\n")}
veganT <- require(vegan)
if(!veganT) {cat("Please install package \'vegan\' before running this script!\n")}
#################################

#################################
##  Step 1: Select & read your file
####

## Select: 
file <- choose.files(multi=F)		# Save file path, 'multi=F' prevents
# selection of more than one file

# Alternatively you can type your file path if you know it allready
# note the double slahes '//'!
# Also: uncomment (remove the '#' of the next example line if want to adapt and use it)
# file <- "D:\\My Dropbox\\Clara\\oligo profile sebas all.txt"

## Read:
oligo <- read.table(file,sep="\t", header=T, row.names=1)
#################################

#################################
## Step 2: Perform calculations
####

## Diversity for all samples:
Simp <- diversity(t(oligo),index="invsimpson")	# Transpose the 'oligo' because that's what the 
Shan <- diversity(t(oligo),index="shannon")	# diversity() expects as input

## Grouping:
# Select samples
samples <- colnames(oligo)

# Set the amount of groups you want to make
groups <- c(1:20)	# Change the '20' into a higher number if you need/want more groups!
G <- tk_select.list(groups, multiple=F, 
                    title="Number of groups over which to divide your samples?")

# Fill the groups with samples and give names
###### This for loop has very difficult commands when one has just
###### started with R. Basically it just names all groups through use input
###### and allows the user to select the boxplot colours
temp.color.new <- "" # needed later...
for (i in 1:G) {
  # Group selecting
  title.g <- paste("Select samples belonging to group ",i,sep="")
  Gtemp <- tk_select.list(samples, multiple=T, 
                          title=title.g)
  
  # Group naming (Not basic stuff here!)
  tt <- tktoplevel()
  name.g <- paste("Type the name of group ",i,sep="")
  tkwm.title(tt,name.g)
  textEntryVarTcl <- tclVar("group x")
  textEntryWidget <- tkentry(tt,width=40,textvariable=textEntryVarTcl)
  tkgrid(tklabel(tt,text="       "))
  tkgrid(tklabel(tt,text="Name:   "),textEntryWidget)
  tkgrid(tklabel(tt,text="       "))
  onOK <- function()
  {
    tempname <<- tclvalue(textEntryVarTcl)
    #cat("\nTemp: ",tempname,"\n"); flush.console()
    tkdestroy(tt)
  }
  OK.but <- tkbutton(tt,text="   OK   ",command=onOK)
  tkgrid(OK.but)
  tkwait.window(tt)
  if(i==1){gr.list<-list(tempname=Gtemp)} else { gr.list<-c(gr.list,list(tempname=Gtemp)) }
  eval(parse(text=paste("names(gr.list)[i]<-tempname")))
  
  # Group colour selection (Not basic stuff here!)
  tc <- tktoplevel()
  tkwm.title(tc,paste("Color Selection for ",tempname,sep=""))
  color <- "blue"
  temp.color.new <<- color
  canvas <- tkcanvas(tc,width="80",height="25",bg=color)
  ChangeColor <- function() {
    color <- tclvalue(tcl("tk_chooseColor",initialcolor=color,title="Choose a color"))
    if (nchar(color)>0)
      tkconfigure(canvas,bg=color)
    temp.color.new <<- color
    #cat("\n\nColour: ",color,"\n\n"); flush.console()
  }
  ChangeColor.button <- tkbutton(tc,text="Change Color",command=ChangeColor)
  onOK2 <- function() {
    tkdestroy(tc)
  }
  Ok.button <- tkbutton(tc,text="Ok, use this colour!",command=onOK2)
  tkgrid(canvas,ChangeColor.button,Ok.button)
  tkwait.window(tc)
  if(i==1){col.list<-list(tempname=temp.color.new)} else { col.list<-c(col.list,list(tempname=temp.color.new)) }
  eval(parse(text=paste("names(col.list)[i]<-tempname")))
}

## "Box-plotting":
# Shannon
boxplot(Shan[gr.list[[1]]], ylab="Shannon Index", col=col.list[[1]],
        ylim=c(min(Shan),max(Shan)),xlim=c(0,length(gr.list))+0.5)
axis(1,labels=names(gr.list),at=c(1:length(gr.list)))

for (i in 2:length(gr.list)) {
  boxplot(Shan[gr.list[[i]]],col=col.list[[i]],names=names(gr.list)[i],add=T,at=i)
}

# Simpson
x11() 		# Opens a new graph window, so the Shannon part above isn't overwritten
# One could implement an automated saving option here...

boxplot(Simp[gr.list[[1]]], ylab="Inverse Simpson's Diversity Index", col=col.list[[1]],
        ylim=c(min(Simp),max(Simp)),xlim=c(0,length(gr.list))+0.5)
axis(1,labels=names(gr.list),at=c(1:length(gr.list)))

for (i in 2:length(gr.list)) {
  boxplot(Simp[gr.list[[i]]],col=col.list[[i]],names=names(gr.list)[i],add=T,at=i)
}

#################################
## Step 3: Save tables
####
save <- tk_select.list(c("yes","no"),multiple=T,
                       title= "Do you want to save the indeces data?")

if(save=="yes") {
  ShanSaveName <- paste(dirname(file),"/Shannon.tab",sep="")
  SimpSaveName <- paste(dirname(file),"/Simpson.tab",sep="")
  write.table(Shan, file=ShanSaveName, sep="\t")
  write.table(Simp, file=SimpSaveName, sep="\t")
}
#################################