<?php

namespace FsaMatch;


class FsaMatch
{
    private $match = [];
    public function __construct($file)
    {
        $file = gzopen($file, 'rb');
        $headers = [
            'name',
            'type',
            'postcode',
            'rating',
            'long',
            'lat',
        ];
        $match = [];
        while(($line = fgetcsv($file)) !== false) {
            if (count($line) !== 6) {
                continue;
            }
           $line = array_combine($headers, $line);
           $line['postcode'] = trim(str_replace(' ', '', $line['postcode']));

           if ($line['postcode'] && empty($match[$line['postcode']])) {
              $match[$line['postcode']] = [];
           }
           $match[$line['postcode']] [] = $line;
        }
        $this->match = $match;
    }

    public function match($name, $postcode)
    {
        $postcode = str_replace(' ', '', $postcode);
        $found = $this->matchByName($name, $postcode);
        if ($found) {
            return $found;
        }

        $found = $this->matchByLetters($name, $postcode);
        if ($found) {
            return $found;
        }

        $found = $this->matchByOnlyPostcode($name, $postcode);
        if ($found) {
            return $found;
        }

        return false;
    }

    public function matchByName($name, $postcode)
    {
        $matches = $this->match[$postcode] ?? [];
        foreach($matches as $index => $match) {
            if (stripos($name, $match['name']) !== false || stripos($match['name'], $name) !== false) {
                unset($this->match[$postcode][$index]);
                return $match;
            }
        }
    }

    public function matchByLetters($name, $postcode)
    {
        $name = preg_replace('/[^a-z]/i', '', $name);

        $matches = $this->match[$postcode] ?? [];
        foreach($matches as $index => $match) {
            $replacedName = preg_replace('/[^a-z]/i', '', $match['name']);
            if (stripos($name, $replacedName) !== false || stripos($replacedName, $name) !== false) {
                unset($this->match[$postcode][$index]);
                return $match;
            }
        }
    }

    public function matchByOnlyPostcode($name, $postcode)
    {
        if (count($this->match[$postcode] ?? []) === 1) {
            $match = current($this->match[$postcode]);
            unset ($this->match[$postcode]);
            return $match;
        }
        return false;
    }
}
