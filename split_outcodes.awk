{
  prev=file;
  split($2, f, " ");
  file="target/outcode-" f[1] ".csv";
  if (prev!=file) close(prev);
  if (headers[file] != "done") {
    print "id,postcode,lat,lon" >> file;
    headers[file] = "done"
  }
  print $0 >> file;
}