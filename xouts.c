#include <libgen.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include <X11/Xlib.h>
#include <X11/extensions/Xrandr.h>

#include "arg.h"

void usage(int status);
void die(const char *errstr, ...);

char *argv0;

bool display_all = true;
bool display_connected;
bool display_disconnected;
bool display_unknownconnection;
bool display_primary;
bool display_secondary;

int
main(int argc, char *argv[])
{
	ARGBEGIN {
		case 'a':
			display_all = true;
			break;
		case 'c':
			display_connected = true;
			display_all = false;
			break;
		case 'd':
			display_disconnected = true;
			display_all = false;
			break;
		case 'p':
			display_primary = true;
			display_all = false;
			break;
		case 's':
			display_secondary = true;
			display_all = false;
			break;
		case 'u':
			display_unknownconnection = true;
			display_all = false;
			break;
		case 'v':
			fprintf(stderr, "%s " VERSION " (c) 2018 Jens Henniges\n", basename(argv0));
			exit(EXIT_SUCCESS);
		case 'h':
			usage(EXIT_SUCCESS);
		default:
			usage(EXIT_FAILURE);
	} ARGEND;

	if (argc > 0)
		die("too many arguments\n");

	Display *disp;
	XRRScreenResources *scrn;
	Window root;
	RROutput prim;
	XRROutputInfo *outp;

	disp = XOpenDisplay(NULL);
	if (!disp)
		die("Can't open display\n");
	root = DefaultRootWindow(disp);
	scrn = XRRGetScreenResources(disp, root);
	prim = XRRGetOutputPrimary(disp, root);

	for (int i = 0; i < scrn->noutput; ++i)
	{
		outp = XRRGetOutputInfo(disp, scrn, scrn->outputs[i]);
		if ((display_all ||
		    (display_connected         && outp->connection == RR_Connected) ||
		    (display_disconnected      && outp->connection == RR_Disconnected) ||
		    (display_unknownconnection && outp->connection == RR_UnknownConnection) ||
		    (display_primary           && scrn->outputs[i] == prim) ||
		    (display_secondary         && scrn->outputs[i] != prim && outp->connection == RR_Connected)
		   ))
		{
			printf("%s\n", outp->name);
		}

		XRRFreeOutputInfo(outp);
	}

	XRRFreeScreenResources(scrn);
	XCloseDisplay(disp);

	return EXIT_SUCCESS;
}



void
usage(int status)
{
	fprintf(stderr, "usage: %s [-acdpsuvh]\n", basename(argv0));
	exit(status);
}


void
die(const char *errstr, ...)
{
	va_list ap;

	va_start(ap, errstr);
	vfprintf(stderr, errstr, ap);
	va_end(ap);
	exit(EXIT_FAILURE);
}
