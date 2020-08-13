function print_to_file(file) {
  if (headers[file] != "done") {
    print "name,postcode,lat,lon" >> file;
    headers[file] = "done"
  }
  print $0 >> file;
  close(file);
}

{
  x = int(($3 - 49.0) / (12.0 / 160.0))
  y = int(($4 + 9) / (11.0 / 80.0))

  if (x >= 0 && x <= 170 && y >= 0 && y <= 90) {

    file_tl="target/pubgrid/" (x-1) "/" (x-1) "-" (y-1) ".csv";
    file_tm="target/pubgrid/" x "/" x "-" (y-1) ".csv";
    file_tr="target/pubgrid/" (x+1) "/" (x+1) "-" (y-1) ".csv";
    file_ml="target/pubgrid/" (x-1) "/" (x-1) "-" y ".csv";
    file_mm="target/pubgrid/" x "/" x "-" y ".csv";
    file_mr="target/pubgrid/" (x+1) "/" (x+1) "-" y ".csv";
    file_bl="target/pubgrid/" (x-1) "/" (x-1) "-" (y+1) ".csv";
    file_bm="target/pubgrid/" x "/" x "-" (y+1) ".csv";
    file_br="target/pubgrid/" (x+1) "/" (x+1) "-" (y+1) ".csv";

    print_to_file(file_tl);
    print_to_file(file_tm);
    print_to_file(file_tr);
    print_to_file(file_ml);
    print_to_file(file_mm);
    print_to_file(file_mr);
    print_to_file(file_bl);
    print_to_file(file_bm);
    print_to_file(file_br);
  } else {
    print "Invalid coordinates " x "/" y " for " $0;
  }
}
