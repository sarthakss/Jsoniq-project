jsoniq version "3.0";
module namespace mm = "http://cs.gmu.edu/~brodsky/univDbPredicates";
import module namespace file = "http://expath.org/ns/file";
import module namespace math = "http://www.w3.org/2005/xpath-functions/math";
import module namespace r= "http://zorba.io/modules/random";
declare namespace ann = "http://zorba.io/annotations";

declare variable $mm:univDB := parse-json(file:read-text("sample530db.json"));
declare variable $mm:allStudents := $mm:univDB.student[].s;
declare variable $mm:allCourses := $mm:univDB.course[].co;
declare variable $mm:allClasses := $mm:univDB.class[].cl;
declare variable $mm:allIstructors := $mm:univDB.class[].instr;
declare variable $mm:allGrades := ("A+","A","A-","B+","B","B-","C","F");
declare variable $mm:allSemesters := $mm:univDB.transcript[].se;
declare variable $mm:allMajor := $mm:univDB.student[].major;
declare variable $mm:allName := $mm:univDB.student[].name;
declare variable $mm:allTitle := $mm:univDB.course[].title;
declare variable $mm:allCredits := $mm:univDB.course[].credits;
declare variable $mm:allPre := $mm:univDB.prereq[].pre;

declare function mm:student($s as string, $name as string, $major as string) as boolean {
  let $truthValue := some $i in $mm:univDB.student[] satisfies ($i.s eq $s and $i.name eq $name and $i.major eq $major)
  return $truthValue
};

declare function mm:course($co as string, $title as string, $credits as string) as boolean {
  let $truthValue := some $i in $mm:univDB.course[] satisfies ($i.co eq $co and $i.title eq $title and $i.credits eq $credits)
  return $truthValue
};

declare function mm:class($cl as string, $co as string, $instr as string, $se as string) as boolean {
  let $truthValue := some $i in $mm:univDB.class[] satisfies ($i.cl eq $cl and $i.co eq $co and $i.inst eq $instr and $i.se eq $se)
  return $truthValue
};

declare function mm:transcript($s as string, $co as string, $grade as string, $se as string) as boolean {
  let $truthValue :=  some $i in $mm:univDB.transcript[]
                      satisfies ($i.s eq $s and $i.co eq $co and $i.grade eq $grade and $i.se eq $se)
  return $truthValue
};

declare function mm:enrolled($s as string, $cl as string) as boolean {
  let $truthValue := some $i in $mm:univDB.enrolled[] satisfies ($i.s eq $s and $i.class eq $cl)
  return $truthValue
};

declare function mm:prereq($co as string, $pre as string) as boolean {
  let $truthValue := some $i in $mm:univDB.prereq[] satisfies ($i.co eq $co and $i.pre eq $pre)
  return $truthValue
};
