<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<include src="../form-md-record/md-record"
    ims_md_id="@ims_md_id;noquote@"
/>

<hr>

<h3>Meta Metadata Contribution</h3>
<blockquote>
  <table cellspacing="2" cellpadding="2" border="0" width="50%">
    <tr class="form-section">
      <th colspan="2">Meta Metadata</th>
    </tr>
    <tr class="form-section">
      <td class="form-section">Contribution: </td>
      <td><listtemplate name= "d_md_cont"></listtemplate></td>
    </tr>   

  </table>
</blockquote>
<p>

<h3>Add/Edit Meta Metadata Contributor</h3>
<blockquote>
 <formtemplate id="metamd_cont" style="standard-lars"></formtemplate>
</blockquote>
