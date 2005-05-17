<master>
  <property name="title">@title@</property>
  <property name="context">@context@</property>

<h2>#lorsm.lt_Courses_in_your_Repos#</h2>

<table width="100%">
  <tr>
    <td valign="top">
        <form action="search" method="GET">
           #lors-central.search_courses# 
           <input name="q" onfocus="if(this.value=='Please type a keyword')this.value='';" onblur="if(this.value=='')this.value='#lors-central.please_type#';" value="#lors-central.please_type#" />
           <input type="submit" value="#lors-central.search#" />
         </form>
     </td>
  <tr>
   <td>
            <listtemplate name="get_courses"></listtemplate>
   </td>
 </tr>
</table>



