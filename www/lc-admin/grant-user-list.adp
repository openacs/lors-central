<master>
<property name=title>@page_title@</property>
<property name="context">@context;noquote@</property>

<table width="100%">
  <tr>
    <td valign="top">
        <form action="" method="GET">
           #lors-central.search_users#:
           <input name="keyword" onfocus="if(this.value=='Please type a keyword')this.value='';" onblur="if(this.value=='')this.value='#lors-central.please_type#';" value="#lors-central.please_type#" />
	   <input type="hidden" name="man_id" value="@man_id@">
	   <input type="hidden" name="creation_user" value="@creation_user@">
           <input type="submit" value="#lors-central.search#" />
         </form>
     </td>
  <tr>
   <td>
       <listtemplate name="grant_list"></listtemplate>
   </td>
 </tr>
</table>

<br>
<h2>#lors-central.memberships#:</h2>
<blockquote>
<if @classes:rowcount@ gt 0>
<h4>#lors-central.class_memberships#:</h4>
<ul>
<table>
     <multiple name="classes">
     <tr>
        <td><li><a href="@classes.url@">@classes.pretty_name@</a></td>
        <td>@classes.term_name@</td>
        <td>@classes.term_year@</td>
	<td>&nbsp;&nbsp;&nbsp;</td>
	<if @classes.associated_p;literal@ true>
	   <td><i>@classes.grant_url;noquote@ / @classes.revoke_url;noquote@ #lors-central.priv_all_memb#</i></td>
        </if>
     </tr>
     </multiple>
</table>
   </ul>
</if>

<if @clubs:rowcount@ gt 0>
<h4>#lors-central.com_memberships#:</h4>
<ul>
  <table>
   <multiple name="clubs">
    <tr>
       <td><li><a href="@clubs.url@">@clubs.pretty_name@</a></td>
       <td>&nbsp;&nbsp;&nbsp;</td>
       <if @clubs.associated_p;literal@ true>
           <td><i> @clubs.grant_url;noquote@ / @clubs.revoke_url;noquote@ #lors-central.priv_all_memb#</i></td>
       </if>
    </tr>
    </multiple>
</table>
</ul>
</if>
</blockquote>

