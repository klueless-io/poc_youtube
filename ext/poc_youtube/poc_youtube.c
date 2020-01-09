#include "poc_youtube.h"

VALUE rb_mPocYoutube;

void
Init_poc_youtube(void)
{
  rb_mPocYoutube = rb_define_module("PocYoutube");
}
