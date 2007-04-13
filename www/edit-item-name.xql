<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!--  -->
<!-- @author Victor Guerra (guerra@galileo.edu) -->
<!-- @creation-date 2007-02-26 -->
<!-- @arch-tag: c20c691d-7c27-4ff5-908e-5c733d4aec67 -->
<!-- @cvs-id $Id$ -->

<queryset>
  
  <fullquery name="update_name">
    <querytext>
      update ims_cp_items set item_title = :name
      where ims_item_id = :ims_item_id
    </querytext>
  </fullquery>
  
</queryset>