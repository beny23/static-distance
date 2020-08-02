$1 != "id" && $3 < 99.9 {
  prev=file;
  prevdir=outdir;
  loc = $2
  gsub(/[^a-zA-Z0-9]/, "", loc)
  loc = toupper(loc)
  loc1 = substr(loc, 1, 1)
  loc2 = substr(loc, 2, 1)
  loc4 = substr(loc, 1, 4)
  outdir = "target/outcode/" loc1 "/" loc2
  file=outdir "/" loc4 ".csv";
  if (prev!=file) {
    close(prev)
  }
  if (prevdir != outdir) {
    cmd="mkdir -p " outdir
    system(cmd)
    close(cmd)
  }
  if (headers[file] != "done") {
    print "id,postcode,lat,lon" >> file;
    headers[file] = "done"
  }
  print $0 >> file;
}