boo	code	import System
boo	code	import System.IO
boo	code	import Gtk from "gtk-sharp"
boo	code	import Gdk from "gdk-sharp"
boo	code	import Glade from "glade-sharp"
boo	blank	
boo	code	class StuffBrowser():
boo	code	  public static final phile = """stuffbrowser.glade"""
boo	blank	
boo	comment	  //Unfortunately, Gtk does not provide a builtin "IsSupported" function for images.
boo	code	  public static final supportedExtensions = ( ".png", ".jpeg", ".jpg", ".gif", ".tga", ".bmp", ".ico", ".tiff" )
boo	blank	
boo	code	  def constructor():
boo	comment	    //Connect event handlers and mainStuff, aboutDialog, etc, to their respective methods/handlers.
boo	code	    for widget in ("mainStuff", "aboutDialog", "directorySelector"):
boo	code	      gxml = Glade.XML(phile, widget, null)
boo	code	      gxml.Autoconnect(self)
boo	blank	
boo	code	  def OnStuffClose(sender as object, e as DeleteEventArgs):
boo	comment	  """The user is leaving the application via the Big Red 'X'"""
boo	code	    Application.Quit()
boo	blank	
boo	code	  def OnStuffQuit(sender as object, e as EventArgs):
boo	comment	  """The user is leaving the application via File-->Quit"""
boo	code	    Application.Quit()
boo	blank	
boo	code	  def OnAboutActivate(sender as object, e as EventArgs):
boo	comment	  """The user is trying to view the about dialog"""
boo	code	    aboutDialog.Show()
boo	blank	
boo	code	  def OnAboutDelete(sender as object, e as DeleteEventArgs):
boo	code	    e.RetVal = true
boo	code	    aboutDialog.Hide()
boo	blank	
boo	code	  def OnAboutResponse(sender as object, e as ResponseArgs):
boo	code	    if e.ResponseId == ResponseType.Close:
boo	code	      aboutDialog.Hide()
boo	blank	
boo	code	  def OnOpenDirectory(sender as object, e as EventArgs):
boo	comment	    #changed
boo	code	    directorySelector.FileList.Sensitive = false
boo	code	    directorySelector.Show()
boo	blank	
boo	code	  def OnDirectoryDelete(sender as object, e as DeleteEventArgs):
boo	code	    e.RetVal = true
boo	code	    directorySelector.Hide() //Don't worry, the "Destroy" event will kill it.
boo	blank	
boo	code	  def OnDirectoryResponse(sender as object, args as ResponseArgs):
boo	code	    directorySelector.Hide()
boo	comment	    #changed
boo	code	    if args.ResponseId == ResponseType.Ok and directorySelector.Filename.Length != 0:
boo	code	      LoadDirectory(directorySelector.Filename)
boo	blank	
boo	code	  private def LoadDirectory(path as string):
boo	comment	    //Create a new store that has two columns; the first is a Pixbuf (image) the second, a string.
boo	code	    store = ListStore( (Gdk.Pixbuf, string)  )
boo	code	    stuffThumbs.Model = store
boo	code	    cell = CellRendererPixbuf()
boo	code	    column = TreeViewColumn()
boo	code	    column.PackStart(cell, false)
boo	blank	
boo	comment	    //Bind the element in column 0 of the store to the pixbuf property in this column's CellRendererPixbuf!
boo	code	    column.AddAttribute(cell, "pixbuf", 0)
boo	code	    column.Title = path
boo	blank	
boo	comment	    //Detach the old column.
boo	code	    if stuffThumbs.GetColumn(0) is not null:
boo	code	      stuffThumbs.RemoveColumn(stuffThumbs.GetColumn(0))
boo	blank	
boo	comment	    //Finally, attach the new column so it will be updated in real time.
boo	code	    stuffThumbs.AppendColumn(column)
boo	code	    files = Directory.GetFiles(path)
boo	code	    validFiles = e for e as string in files if System.IO.FileInfo(e).Extension in StuffBrowser.supportedExtensions
boo	code	    parse = do():
boo	code	      for i as int, file as string in enumerate(validFiles):
boo	comment	        //The using construct ensures that the program's memory size does not inflate wildly out of control.
boo	comment	        //Having these "image" floating around afterwards ensures lots of memory consuming havoc until garbaged collected!
boo	comment	        #changed
boo	comment	        // If we couldn't read a file pass over it.
boo	code	        try:
boo	code	          using image = Gdk.Pixbuf(file):
boo	code	            store.AppendValues( (image.ScaleSimple(128, 128, InterpType.Bilinear), file ) )
boo	code	        except e:
boo	code	          print " Couldn't read file ${file} "
boo	blank	
boo	code	    print "Indexing start: ${DateTime.Now}"
boo	comment	    //Update the treeview in real time by starting an asynchronous operation.
boo	code	    parse.BeginInvoke( { print "Indexing complete: ${DateTime.Now}" } ) //Spin off a new thread; fill the progress bar.
boo	blank	
boo	code	  def OnPictureActivated(sender as object, args as RowActivatedArgs):
boo	comment	    //Grabs the TreeIter object that represents the currently selected node -- icky stuff with "ref" keyword. ;(
boo	code	    x as TreeIter
boo	code	    stuffThumbs.Model.GetIter(x, args.Path)
boo	blank	
boo	comment	    //In the second column we've stored the filename that represents the thumbnail image in the treeview.
boo	comment	    //Grab this filename and then use it to inform the user what file he's viewing, as well as loading it.
boo	code	    image = stuffThumbs.Model.GetValue(x, 1) as string
boo	code	    stuffImage.Pixbuf = Gdk.Pixbuf(image)
boo	code	    imageName.Text = Path.GetFileName(image)
boo	blank	
boo	comment	  //All of the widgets we want Autoconnect to hook up to Glade-created widgets in stuffBrowser.glade
boo	code	  [Glade.Widget] aboutDialog as Gtk.Dialog
boo	code	  [Glade.Widget] mainStuff as Gtk.Window
boo	code	  [Glade.Widget] directorySelector as Gtk.FileSelection
boo	code	  [Glade.Widget] stuffImage as Gtk.Image
boo	code	  [Glade.Widget] stuffThumbs as Gtk.TreeView
boo	code	  [Glade.Widget] imageName as Gtk.Label
boo	blank	
boo	comment	//Run the application.
boo	code	Application.Init()
boo	code	StuffBrowser()
boo	code	Application.Run()
