java	comment	// Program 11.6: A nicer sine wave
java	code	import java.applet.Applet;    
java	code	import java.awt.Graphics; 
java	blank	
java	code	public class SineApplet2 extends Applet {
java	blank	
java	code		public void paint(Graphics g) {
java	blank	
java	code			int i, j1, j2;
java	blank	
java	code			j1 = yvalue(0);
java	code			for (i = 0; i < size().width; i++) {
java	code				j2 = yvalue(i+1);
java	code				g.drawLine(i, j1 ,i+1, j2);
java	code				j1 = j2;
java	code			}
java	blank	
java	code		}
java	blank	
java	comment		// Given the  xpoint we're given calculate the Cartesian equivalent
java	code		private int yvalue(int ivalue)  {
java	blank	
java	code			double xmin = -10.0;
java	code			double xmax =  10.0;
java	code			double ymin = -1.0;
java	code			double ymax =  1.0;
java	code			double x, y;
java	code			int jvalue;
java	blank	
java	code			x = (ivalue * (xmax - xmin)/(size().width - 1)) + xmin;
java	blank	
java	comment			// Take the sine of that x 
java	code			y = Math.sin(x);
java	blank	
java	comment			// Scale y into window coordinates
java	code			jvalue = (int) ((y - ymin)*(size().height - 1)/
java	code					(ymax - ymin));
java	blank	
java	comment			/* Switch jvalue from Cartesian coordinates 
java	comment				 to computer graphics coordinates */   
java	code			jvalue = size().height - jvalue;
java	blank	
java	code			return jvalue;
java	blank	
java	code		}
java	blank	
java	code	}
java	blank	
