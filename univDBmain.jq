jsoniq version "3.0";
import module namespace im= "http://cs.gmu.edu/~brodsky/univDbPredicates";
import module namespace file = "http://expath.org/ns/file";

let
  $allClasses := $im:allClasses,
  $allStudents := $im:allStudents,
  $allCourses := $im:allCourses,
  $allInstructor := $im:allInstructor,
  $allGrades := $im:allGrades,
  $allSemesters := $im:allSemesters,
  $allMajor := $im:allMajor,
  $allName := $im:allName,
  $allTitle := $im:allTitle,
  $allCredits := $im:allCredits,
  $allPre := $im:allPre,


  (: boolean query A :)
  $boolQueryA := some $g in $im:allGrades, $se in $im:allSemesters
                    satisfies im:transcript("G113","CS530",$g,$se),

  (: boolean query B :)
  $boolQueryB := some $s in $im:allStudents, $major in $im:allMajor, $g in $im:allGrades, $se in $im:allSemesters
                    satisfies im:student($s,"John Smith",$major)
                    and im:transcript($s,"CS530",$g,$se),

  (: boolean query C :)
  $boolQueryC := for $s in $im:allStudents
                 where some $major in $im:allMajor, $g in $im:allGrades, $se in $im:allSemesters
                    satisfies not im:student($s,"John Smith",$major)
                    or im:transcript($s,"CS530",$g,$se),

 (: boolean query D :)
 $boolQueryD := for $cl in $im:allClasses
                satisfies not [im:enrolled("G113",$cl)
                and some $co in $im:allCourses, $instr in $im:allIstructors
                im:class($cl,$co,$instr)]
                or im:hassat($s,$cl)
                where im:hassat($s,$cl) is
                for $pre in $im:allPre
                some $s in $im:allStudents
                satisfies
                not im:prereq($co,$pre)
                or
                some $g in $im:allGrades, $se in $im:allSemesters
                im:transcript($s,$pre,$g,$se),

(: boolean query E :)
$boolQueryE := for $s in $im:allStudents
               where some $co in $im:allCourses, $instr in $im:allIstructors, $cl in $im:allClasses
               satisfies not im:class($cl,$co,$instr)
               or im:hassat($s,$cl)
               where im:hassat($s,$cl) is
               for $pre in $im:allPre
               some $s in $im:allStudents
               satisfies
               not im:prereq($co,$pre)
               or
               some $g in $im:allGrades, $se in $im:allSemesters
               im:transcript($s,$pre,$g,$se),

(: boolean query F :)
$boolQueryF := for $s in $im:allStudents
               where some $name in $im:allName
               satisfies
               not [im:student($s,$name,"CS")
               and some $co in $im:allCourses, $instr in $im:allIstructors, $cl in $im:allClasses
               im:class($cl,$co,$instr)]
               or im:hassat($s,$cl)
               where im:hassat($s,$cl) is
               for $pre in $im:allPre
               some $s in $im:allStudents
               satisfies
               not im:prereq($co,$pre)
               or
               some $g in $im:allGrades, $se in $im:allSemesters
               im:transcript($s,$pre,$g,$se),

(: boolean query G :)
$boolQueryG := some $s in $im:allStudents, $major in $im:allMajor
               satisfies im:student($s,"John Smith",$major)
               and
               some $cl in $im:allClasses
               im:enrolled($s,$cl)
               and some $co in $im:allCourses, $instr in $im:allIstructors, $cl in $im:allClasses
               im:class($cl,$co,$instr)]
               and
               im:hassat($s,$cl)
               where im:hassat($s,$cl) is
               for $pre in $im:allPre
               satisfies
               not im:prereq($co,$pre)
               or
               some $g in $im:allGrades, $se in $im:allSemesters
               im:transcript($s,$pre,$g,$se),

(: boolean query H :)
$boolQueryH := for $pre in $im:allPre
               where some $co in $im:allCourses, $title in $im:allTitle, $credits in $im:allCredits,
               satisfies im:courses($co,$title,$credits)
               and not
               im:prereq($co,$pre),

(: boolean query I :)
$boolQueryI := for $cl in $im:allClasses
               where some $s in $im:allStudents, $co in $im:allCourses
               satisfies not im:offer($s,$co)
               or im:pre1($cl,$co)
               where im:offer($s,$co) is
               some $instr in $im:allIstructors
               im:class($cl,$co,$instr) and
               some $g in $im:allGrades, $se1 in $im:allSemesters
               im:transcript($s,$co,$g,$se1)
               where im:pre1($cl,$co) is
               some $instr in $im:allIstructors
               im:class($cl,$co,$instr) and
               some $pre in $im:allPre
               im:prereq($pre,$co),

(: boolean query j :)
$boolQueryJ := for $co in $im:allCourses
               where some $s in $im:allStudents, $g in $im:allGrades, $se1 in $im:allSemesters
              satisfies not im:transcript($s,$co,$g,$se)
              or ($g == 'A' or $g == 'B'),

(: boolean query k :)
$boolQueryK := for $s in $im:allStudents
               where some $name in $im:allName
               satisfies not
               im:student($s,$name,"CS")
               or
               some $cl in $im:allClasses, $co in $im:allCourses
               im:class($cl,$co,"Brodsky"),

(: boolean query l :)
$boolQueryL := some $s in $im:allStudents, $name in $im:allName
               satisfies
               im:student($s,$name,"CS")
               and
               some $cl in $im:allClasses, $co in $im:allCourses
               im:class($cl,$co,"Brodsky"),

(: boolean query M :)
$boolQueryM := for $s in $im:allStudents
               where some $name in $im:allName, $cl in $im:allClasses
               satisfies
               im:student($s,$name,"CS")
               and
               im:enrolled($s,$cl)
               and
               some $co in $im:allCourses
               im:class($cl,$co,"Brodsky"),




  (: data query A :)
  $dataQueryA :=
    for $s in $allStudents
    where some $g in $im:allGrades, $se in $im:allSemesters
      satisfies im:transcript($s,"CS530",$g,$se)
      return $s,

  (: data query B :)
  $dataQueryB :=
    for $s in $allStudents
    where some $major in $im:allMajor, $g in $im:allGrades, $se in $im:allSemesters
      satisfies im:student($s,"John Smith",$major)
      and im:transcript($s,"CS530",$g,$se)
      return $s,

 (: data query C :)
 $dataQueryC :=
   for $s in $allStudents
   where some $co in $im:allCourses, $instr in $im:allIstructors
   satisfies not im:class($cl,$co,$instr)]
   or im:hassat($s,$cl)
   where im:hassat($s,$cl) is
   for $pre in $im:allPre
   satisfies
   not im:prereq($co,$pre)
   or
   some $g in $im:allGrades, $se in $im:allSemesters
   im:transcript($s,$pre,$g,$se)
   return $s,

   (: data query D :)
   $dataQueryD := for $s in $im:allStudents
                  where for $cl in $im:allClasses
                  satisfies im:enrolled($s,$cl)
                  and some $co in $im:allCourses, $instr in $im:allIstructors
                  im:class($cl,$co,$instr)
                  and im:hasnotsat($s,$cl)
                  where im:hasnotsat($s,$cl) is
                  for $pre in $im:allPre
                  satisfies
                  im:prereq($co,$pre)
                  and not
                  some $g in $im:allGrades, $se in $im:allSemesters
                  im:transcript($s,$pre,$g,$se)
                  return $s,

  (: data query E :)
  $dataQueryE := for $s in $im:allStudents
                 where for $cl in $im:allClasses
                 some $major in $im:allMajor
                 satisfies
                 im:student($s,"John Smith",$major)
                 and
                 im:enrolled($s,$cl)
                 and some $co in $im:allCourses, $instr in $im:allIstructors
                 im:class($cl,$co,$instr)]
                 and im:hasnotsat($s,$cl)
                 where im:hasnotsat($s,$cl) is
                 for $pre in $im:allPre
                 satisfies
                 im:prereq($co,$pre)
                 and not
                 some $g in $im:allGrades, $se in $im:allSemesters
                 im:transcript($s,$pre,$g,$se),
                 return $s,

 (: data query F :)
 $dataQueryF := for $co in $im:allCourses
                where for $pre in $im:allPre
                some $title in $im:allTitle, $co in $im:allCourse
                satisfies im:course($co,$title,$credits)
                and not
                im:prereq($co,$pre)
                return $co,

(: data query G :)
$dataQueryG := for $co in $im:allCourses
               where for $pre in $im:allPre
               some $title in $im:allTitle, $co in $im:allCourse
               satisfies im:course($co,$title,$credits)
               and
               im:prereq($co,$pre)
               return $co,

(: data query H :)
$dataQueryH := for $cl in $im:allClasses
               where some $s in $im:allStudents, $co in $im:allCourses
               satisfies not im:offer($s,$co)
               or im:pre1($cl,$co)
               where im:offer($s,$co) is
               some $instr in $im:allIstructors
               im:class($cl,$co,$instr) and
               some $g in $im:allGrades, $se1 in $im:allSemesters
               im:transcript($s,$co,$g,$se1)
               where im:pre1($cl,$co) is
               some $instr in $im:allIstructors
               im:class($cl,$co,$instr) and
               some $pre in $im:allPre
               im:prereq($pre,$co)
               return $cl,

(: data query I :)
$dataQueryI := for $co in $im:allCourses
               where some $s in $im:allStudents, $g in $im:allGrades, $se1 in $im:allSemesters
               satisfies not im:transcript($s,$co,$g,$se)
               or ($g == 'A' or $g == 'B'),
               return $co,


(: data query J :)
$dataQueryJ := for $s in $im:allStudents
               where some $name in $im:allName, $cl in $im:allClasses
               satisfies
               im:student($s,$name,"CS")
               and
               im:enrolled($s,$cl)
               and
               some $co in $im:allCourses
               im:class($cl,$co,"Brodsky")
               return $s,



  return {
      allClasses:$allClasses,
      allStudents:$allStudents,
      allCourses := $allCourses,
      allInstructor := $allInstructor,
      allGrades := $allGrades,
      allSemesters := $allSemesters,
      allMajor := $allMajor,
      allName := $allName,
      allTitle := $allTitle,
      allCredits := $allCredits,
      allPre := $allPre,
      boolQueryA:$boolQueryA,
      boolQueryB:$boolQueryB,
      boolQueryC:$boolQueryC,
      boolQueryD:$boolQueryD,
      boolQueryE:$boolQueryE,
      boolQueryF:$boolQueryF,
      boolQueryG:$boolQueryG,
      boolQueryH:$boolQueryH,
      boolQueryI:$boolQueryI,
      boolQueryJ:$boolQueryJ,
      boolQueryK:$boolQueryK,
      boolQueryL:$boolQueryL,
      boolQueryM:$boolQueryM,
      dataQueryA:$dataQueryA,
      dataQueryB:$dataQueryB,
      dataQueryC:$dataQueryC,
      dataQueryD:$dataQueryD,
      dataQueryE:$dataQueryE,
      dataQueryF:$dataQueryF,
      dataQueryG:$dataQueryG,
      dataQueryH:$dataQueryH,
      dataQueryI:$dataQueryI,
      dataQueryJ:$dataQueryJ,


    }
